policy 'asgard-demo-0.0.4' do
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

  users = group "asgard-users", name: "Users of Asgard"

  asgard = layer 'asgard', name: "production Asgard hosts" do
    variables.each { |var| can 'execute', var }
    add_member "use_host", users
  end

end
