require 'json'
require 'conjur/cli'

Launch = Struct.new(:service, :options) do
  def run
    policy = JSON.parse(File.read("policy.json"))
    host_id = policy['api_keys'].keys.find{|k| k.split(":")[1] == "host" && k.split(":")[2] =~ /\/docker\/#{service}$/}
    raise "Service '#{service}' not found" unless host_id
    host_api_key = policy['api_keys'][host_id]
    appliance_url = Conjur.configuration.appliance_url or raise "No appliance_url in Conjur config"
    cert = Conjur::Config['cert_file'] or raise "No cert_file in Conjur config"
    cert = File.read(cert)
      
    env = {
      'CONJUR_APPLIANCE_URL' => Conjur.configuration.appliance_url,
      'CONJUR_ACCOUNT' => Conjur.configuration.account,
      'CONJUR_CERT' => cert,
      'CONJUR_LOGIN' => "host/#{host_id.split(':')[1]}",
      'CONJUR_PASSWORD' => host_api_key
    }
    env_args = env.keys.map{|k| "-e #{k}"}.join(' ')
      
    args = [
      "docker run #{env_args} --name #{service} --rm divide/asgard-conjur:#{service}"
    ]
    
    puts args

    Kernel.system(env, *args) or exit($?.to_i) # keep original exit code in case of failure
  end
end
