require 'yaml'
require 'erb'

NETRC_PATH = '/etc/conjur.identity'
CERT_FILE = '/etc/conjur.pem'

class ConfigFile
  def self.conf_erb name
    path = File.expand_path "../templates/#{name}.erb", __FILE__
    erb = ERB.new File.read(path)
    erb.filename = path
    erb.def_method self, :conf, path
  end
end

# utility function to easily get CONJUR_ envars
def env var
  var = "CONJUR_#{var}".upcase
  ENV[var] || fail(ArgumentError, "#{var} not set")
end

class ContainerConfig
  # open outer port as a Conjur-gated proxy to inner
  def gate outer, to: nil
    set_conjur_upstream
    nginx.servers << NginxGate.new(outer, to)
  end

  # reverse proxy listen to target host
  def proxy listen, to: nil
    nginx.upstreams[to] = to
    nginx.servers << NginxProxy.new(listen, to)
  end

  # Configure the Conjur client
  def configure_conjur
    return if @conjur_configured
    File.write CERT_FILE, env('cert')

    conf = {
      appliance_url: env('appliance_url'),
      account: env('account'),
      netrc_path: NETRC_PATH,
      cert_file: CERT_FILE
    }

    File.write '/etc/conjur.conf', conf.to_yaml

    File.write NETRC_PATH, """
      machine #{env('appliance_url')}/authn
      login #{env('authn_login')}
      password #{env('authn_api_key')}
    """, perm: 0600
    @conjur_configured = true
  end

  # Rewrite conjur env YAML file IN PLACE to include policy name
  # (set in $CONJUR_POLICY). Every !var and !tmp entry which starts with a
  # slash is prefixed with the name.
  def apply_policy path
    envdef = YAML.parse_stream File.read(path)
    policy = env('policy')

    envdef.each do |node|
      if %w(!var !tmp).include? node.tag and node.value.start_with? '/'
        node.value.prepend policy
      end
    end

    File.write path, envdef.yaml
  end

  # load a container configuration and apply it
  def self.load path
    config = new path
    config.finalize
  end

  # write out pending config files
  def finalize
    File.write '/etc/nginx/nginx.conf', nginx.conf
  end

  private

  def set_conjur_upstream
    # pick hostname plus HTTPS port
    nginx.upstreams["conjur"] = env('appliance_url').sub(%r{^.*//([^/]+)/.*}, '\1') + ":443"
  end

  def initialize path
    @nginx = Nginx.new
    instance_eval File.read(path), path
  end

  attr_reader :nginx

  class Nginx < ConfigFile
    def initialize
      @servers = []
      @upstreams = {}
    end

    attr_reader :servers, :upstreams

    conf_erb 'nginx.conf'
  end

  class NginxGate < ConfigFile
    def initialize outer, inner
      @inner = inner
      @outer = outer
    end

    attr_reader :inner, :outer

    def method_missing meth, *a
      super if block_given? || !a.empty?
      env meth
    end

    conf_erb 'conjur-gate.conf'

    def conf_file
      path = "/etc/nginx/conjur-gate-#{outer}.conf"
      File.write path, conf
      path
    end
  end

  class NginxProxy < ConfigFile
    def initialize listen, host
      @listen = listen
      @host = host
    end

    def encoded_login
      CGI.escape authn_login
    end

    attr_reader :listen, :host

    def method_missing meth, *a
      super if block_given? || !a.empty?
      env meth
    end

    conf_erb 'conjur-proxy.conf'

    def conf_file
      path = "/etc/nginx/conjur-proxy-#{listen}.conf"
      File.write path, conf, perm: 0600 # there's an API key there
      path
    end
  end
end
