policy 'asgard-demo-0.1.0' do
  variables = []

  [
    ['aws_account', 'AWS account numeric ID'],
    ['aws_access_key_id', 'AWS access key ID'],
    ['aws_secret_access_key', 'AWS secret access key']
  ].each do |var, name|
    variables.push variable(var, name: name)
  end

  asgard_service = resource "webservice", "asgard"
  eureka_service = resource "webservice", "eureka"

  role "client", "users" do |r|
    asgard_service.permit "execute", r
    eureka_service.permit "execute", r
  end

  layer 'asgard' do
    for var in variables
      can 'execute', var
    end
    
    can 'execute', eureka_service
  end

  layer 'eureka'
end
