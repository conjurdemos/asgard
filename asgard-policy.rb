policy 'asgard-demo-0.0.2' do
  variables = []

  group 'asgard-managers', name: 'Credential managers for Asgard' do
    owns do
      [
        ['aws_account', 'AWS account numeric ID'],
        ['aws_access_key_id', 'AWS access key ID'],
        ['aws_secret_access_key', 'AWS secret access key']
      ].each do |var, name|
        variables.push(variable var, name: name)
      end
    end
  end

  asgard = layer 'asgard', name: "production Asgard hosts" do
    variables.each { |var| can 'execute', var }
  end

  group "asgard-users", name: "Users of Asgard" do
    can "execute", asgard
  end
end
