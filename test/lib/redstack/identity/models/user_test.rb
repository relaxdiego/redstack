require_relative '../../../../test_helper'

include RedStack::Identity::Models

describe 'RedStack::Identity::Models::User' do

  before do
    @os = new_openstack_session

    @admin               = TestFixtures.users[:admin]
    @admin_project       = TestFixtures.projects[:admin_project]
    @admin_default_token = Token.create(
                             connection: @os.connection,
                             attributes: {
                               username: @admin[:username], 
                               password: @admin[:password]
                             }
                           )
    @admin_scoped_token  = Token.create(
                             connection: @os.connection,
                             attributes: {
                               token:    @admin_default_token, 
                               project:  @admin_project[:name]
                             }
                           )
    
    @non_admin              = TestFixtures.users[:non_admin]
    @non_admin_project      = TestFixtures.projects[:non_admin_project]
    @nonadmin_default_token = Token.create(
                                connection: @os.connection,
                                attributes: {
                                  username: @non_admin[:username], 
                                  password: @non_admin[:password]
                                }
                              )
    @nonadmin_scoped_token  = Token.create(
                                connection: @os.connection,
                                attributes: {
                                  token:    @nonadmin_default_token, 
                                  project:  @non_admin_project[:name]
                                }
                              )
  end
  
  it 'retrieves users when a valid scoped token is provided' do  
    users = User.find(token: @admin_scoped_token, connection: @os.connection)
    
    users.must_be_instance_of Array
    users.length.wont_be_nil
  end
  
  
  it 'raises an error when finding users and an unscoped token is provided' do
    find_method = lambda { User.find(token: @nonadmin_default_token, connection: @os.connection) } 
    find_method.must_raise ArgumentError
    find_method.call rescue $!
  end
  
  
  it 'raises an error when finding users and a scoped token without the requisite permission is provided' do
    find_method = lambda { User.find(token: @nonadmin_scoped_token, connection: @os.connection) } 
    find_method.must_raise RedStack::NotAuthorizedError
    error = find_method.call rescue $!
    error.message.wont_be_nil
  end


  it 'creates a user when a valid token is provided' do
    attributes = {
      username: 'redstacknewuser',
      name:     'RedStack New User',
      email:    'redstacknewuser@gmail.com',
      enabled:  true,
      password: 'secrete'
    }
    
    user = User.create(
             token:      @admin_scoped_token, 
             connection: @os.connection,
             attributes: attributes
           )
    
    # The querystring argument ensures that Faraday doesn't match against the 
    # User.find query made in other tests which will not return this user.
    users = User.find(
              token:        @admin_scoped_token, 
              connection:   @os.connection, 
              querystring: 'after_user_create'
            )
    users.find{ |u| u.username == attributes[:username] }.wont_be_nil "User '#{ attributes[:username] }' was not created"
    
    # Cleanup
    user.delete!
  end
end