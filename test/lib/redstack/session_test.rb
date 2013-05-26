require_relative '../../test_helper'
 
describe 'RedStack::Session' do
  
  before do
    @os = RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0', stub_openstack: true)
  end
   
  it 'authenticates against the backend' do  
    @os.authenticate username: 'validuser', password: '123qwe'
    
    @os.authenticated?.must_equal true
    @os.access.wont_be_nil
    @os.access.must_be_instance_of RedStack::Access
  end
  
  it 'handles invalid usernames' do
    @os.authenticate username: 'invaliduser', password: '123qwe'
    
    @os.authenticated?.must_equal false
    @os.access.must_be_nil
  end
  
  it 'has a projects method' do
    @os.authenticate username: 'validuser', password: '123qwe'
    
    @os.projects.must_be_instance_of RedStack::Controllers::Identity::ProjectsController
    @os.projects.session.must_equal @os
  end
 
end