require_relative '../../test_helper'
 
describe 'RedStack::Session' do
  
  before do
    @non_admin = TestFixtures.users[:non_admin]
    @os        = new_openstack_session
    
    @os.authenticate username: @non_admin[:username], password: @non_admin[:password]
  end
  
  it 'authenticates against the backend' do  
    non_admin = TestFixtures.users[:non_admin]
    os        = new_openstack_session
    
    os.authenticate username: non_admin[:username], password: non_admin[:password]
    
    os.authenticated?.must_equal true
    os.tokens[:default].wont_be_nil
  end
  
  it 'handles invalid usernames' do
    non_admin = TestFixtures.users[:non_admin]
    os        = new_openstack_session
    
    os.authenticate username: 'invaliduserhere', password: non_admin[:password]
      
    os.authenticated?.must_equal false
    os.tokens[:default].must_be_nil
  end
  
  it 'fetches projects' do      
    projects = @os.find_projects
    
    projects.wont_be_nil
  end
  
  # it 'has is_admin? method' do
  #   @os.must_respond_to :is_admin?
  # end
  # 
  # it 'can request for admin access' do
  #   @os.authenticate username: 'admin', password: 'password'
  #   
  #   @os.is_admin?.must_equal false
  #   @os.request_admin_access.must_equal true
  #   @os.is_admin?.must_equal true
  # end
 
end