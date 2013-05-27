require_relative '../../test_helper'
 
describe 'RedStack::Session' do
  
  before do
    @os = new_openstack_session
    @os.authenticate username: 'validuser', password: '123qwe'
  end
   
  it 'authenticates against the backend' do  
    @os = new_openstack_session
    @os.authenticate username: 'validuser', password: '123qwe'
    
    @os.authenticated?.must_equal true
    @os.access['default'].wont_be_nil
    @os.access.wont_be_nil
  end
  
  it 'handles invalid usernames' do
    @os = new_openstack_session
    @os.authenticate username: 'invaliduser', password: '123qwe'
    
    @os.authenticated?.must_equal false
    @os.access.wont_be_nil
    @os.access['default'].must_be_nil
  end
  
  it 'has a projects method' do  
    @os.projects.must_be_instance_of RedStack::Controllers::Identity::ProjectsController
    @os.projects.session.must_equal @os
  end
  
  it 'has is_admin? method' do
    @os.must_respond_to :is_admin?
  end
  
  it 'can request for admin access' do
    @os.authenticate username: 'admin', password: 'password'
    
    @os.is_admin?.must_equal false
    @os.request_admin_access.must_equal true
    @os.is_admin?.must_equal true
  end
 
end