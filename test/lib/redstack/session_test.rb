require_relative '../../test_helper'
 
describe "RedStack::Session" do
 
  host        = 'http://devstack:5000'
  api_version = 'v2.0'
 
  it "must be defined" do
    RedStack::Session.wont_be_nil
  end
  
  it "constructs a session object" do
    os = RedStack::Session.new(host: host, api_version: api_version)

    os.must_be_instance_of RedStack::Session
    os.uri.must_equal URI.join(host, api_version)
  end
  
  it "authenticates against the backend" do
    response = mock_unscoped_access_response(username: 'john')
    
    
    os = RedStack::Session.new(host: host, api_version: api_version)
    os.authenticate username: 'john', password: 'doe'
    
    os.access.must_be_instance_of RedStack::Access
    fail
    # os.access.must_equal RedStack::Access.new
  end
 
end