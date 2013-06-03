require_relative '../../../../test_helper'

include RedStack::Identity::Models

describe 'RedStack::Identity::Models::Token' do

  before do
    @os         = new_openstack_session
    @non_admin  = TestFixtures.users[:non_admin]
    @admin      = TestFixtures.users[:admin]
    
    @non_admin_project = TestFixtures.projects[:non_admin_project]
    @admin_project     = TestFixtures.projects[:admin_project]
  end
  
  it 'creates a default token when valid user credentials are provided' do
    token = Token.create(
              username:   @non_admin[:username], 
              password:   @non_admin[:password], 
              connection: @os.connection
            )
    
    token.must_be_instance_of Token
    token.id.must_be_instance_of String
    token.is_default?.must_equal true
    token.is_unscoped?.must_equal true
  end
  
  
  it 'creates a scoped token when a valid default token and project name are provided' do
    default_token = Token.create(
                      username:   @non_admin[:username], 
                      password:   @non_admin[:password], 
                      connection: @os.connection
                    )
    
    scoped_token  = Token.create(
                      token:      default_token, 
                      project:    @non_admin_project[:name], 
                      connection: @os.connection
                    )
    
    scoped_token.must_be_instance_of Token
    scoped_token.is_default?.must_equal false
    scoped_token.is_scoped?.must_equal true
  end


  it 'has a [] method which is a proxy to token.data[]' do
    token = Token.create(
              username:   @non_admin[:username], 
              password:   @non_admin[:password], 
              connection: @os.connection
            )

    
    token.data.keys.each do |key|
      token[key].must_equal token.data[key]
    end
  end
  
  
  it 'creates a token with an error message when invalid credentials are provided' do
    token = Token.create(
              username:   'invaliduserzzz', 
              password:   'asdlfkj123', 
              connection: @os.connection
            )
    
    token.error.wont_be_nil
    token.id.must_be_nil
  end
  
  
  it 'validates itself against the backend' do
    # Get a scoped token for the admin user (which should have access to admin enpoints)
    default_token = Token.create(
                      username:   @admin[:username], 
                      password:   @admin[:password], 
                      connection: @os.connection
                    )
    scoped_token  = Token.create(
                      token:      default_token, 
                      project:    @admin_project[:name], 
                      connection: @os.connection
                    )
    
    # Now get a different default token for a different user
    default_token = Token.create(
                      username:   @non_admin[:username], 
                      password:   @non_admin[:password],
                      connection: @os.connection
                    )
    
    # Validate this default token
    result = default_token.validate!(admin_token: scoped_token, connection: @os.connection)
    
    default_token.error.must_be_nil
    result.must_equal true
  end
  
  
  it 'returns false when the token is invalid' do
    # Get a scoped token for the admin user (which should have access to admin enpoints)
    default_token = Token.create(
                      username:   @admin[:username], 
                      password:   @admin[:password], 
                      connection: @os.connection
                    )
    scoped_token  = Token.create(
                      token:      default_token, 
                      project:    @admin_project[:name], 
                      connection: @os.connection
                    )
    
    # Now get a different default token for a different user
    default_token = Token.create(
                      username:   @non_admin[:username], 
                      password:   @non_admin[:password],
                      connection: @os.connection
                    )
    
    # Change the token id to make it invalid
    default_token.data['token']['id'].gsub!(/./, 'A')
    
    # Validate this default token
    result = default_token.validate!(admin_token: scoped_token, connection: @os.connection)

    default_token.error.wont_be_nil
    result.must_equal false
  end
       
end