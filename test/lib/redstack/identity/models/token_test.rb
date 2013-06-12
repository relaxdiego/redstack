require 'test_helper'

class IdentityTokenTests < MiniTest::Spec

  include RedStack::Identity::Models
  include CommonTestHelperMethods

  # Helper methods specific to these tests

  # Add 'em here!

  # Tests

  describe 'RedStack::Identity::Models::Token::create' do

    it 'creates a default token with valid user credentials' do
      token = Token.create(
                connection: os.connection,
                attributes: {
                  username: non_admin_attrs[:username],
                  password: non_admin_attrs[:password]
                }
              )

      token.must_be_instance_of Token
      token[:id].must_be_instance_of String
      token.is_default?.must_equal true
      token.is_unscoped?.must_equal true
    end


    it 'creates a scoped token with a valid default token and project name' do
      default_token = Token.create(
                        connection: os.connection,
                        attributes: {
                          username: non_admin_attrs[:username],
                          password: non_admin_attrs[:password]
                        }
                      )

      scoped_token  = Token.create(
                        connection: os.connection,
                        attributes: {
                          token:    default_token,
                          project:  non_admin_project_attrs[:name]
                        }
                      )

      scoped_token.must_be_instance_of Token
      scoped_token.is_default?.must_equal false
      scoped_token.is_scoped?.must_equal true
    end


    it 'creates a scoped token with valid credentials and a project name' do
      scoped_token  = Token.create(
                        connection: os.connection,
                        attributes: {
                          username: non_admin_attrs[:username],
                          password: non_admin_attrs[:password],
                          project:  non_admin_project_attrs[:name]
                        }
                      )

      scoped_token.must_be_instance_of Token
      scoped_token.is_default?.must_equal false
      scoped_token.is_scoped?.must_equal true
    end


    it 'raises an error message when invalid credentials are provided' do
      create_method = lambda do
        Token.create(
          connection: os.connection,
          attributes: {
            username: 'invaliduserzzz',
            password: 'asdlfkj123'
          }
        )
      end

      create_method.must_raise RedStack::NotAuthorizedError
      error = create_method.call rescue $!
      error.message.wont_be_nil
    end

  end


  describe 'RedStack::Identity::Models::Token#[]' do

    it 'aliases Token#data[]' do
      token = Token.create(
                connection: os.connection,
                attributes: {
                  username: non_admin_attrs[:username],
                  password: non_admin_attrs[:password]
                }
              )

      token.data.keys.each do |key|
        token[key].must_equal token.data[key]
      end
    end

  end


  describe 'RedStack::Identity::Models::Token#validate' do

    it 'returns true when other token is valid' do
      # Get a scoped token for the admin user (which should have access to admin enpoints)
      default_token = Token.create(
                        connection: os.connection,
                        attributes: {
                          username:   admin_attrs[:username],
                          password:   admin_attrs[:password]
                        }
                      )
      admin_token  = Token.create(
                        connection: os.connection,
                        attributes: {
                          token:    default_token,
                          project:  admin_project_attrs[:name]
                        }
                      )

      # Now get a different default token for a different user
      default_token = Token.create(
                        connection: os.connection,
                        attributes: {
                          username: non_admin_attrs[:username],
                          password: non_admin_attrs[:password]
                        }
                      )

      # Validate default token
      result = admin_token.validate(token: default_token)

      default_token.error.must_be_nil
      result.must_equal true
    end


    it 'returns false when other token is invalid' do
      # Get a scoped token for the admin user (which should have access to admin enpoints)
      default_token = Token.create(
                        connection: os.connection,
                        attributes: {
                          username: admin_attrs[:username],
                          password: admin_attrs[:password]
                        }
                      )
      admin_token  = Token.create(
                        connection: os.connection,
                        attributes: {
                          token:    default_token,
                          project:  admin_project_attrs[:name]
                        }
                      )

      # Now get a different default token for a different user
      default_token = Token.create(
                        connection: os.connection,
                        attributes: {
                          username: non_admin_attrs[:username],
                          password: non_admin_attrs[:password]
                        }
                      )

      # Change the token id to make it invalid
      default_token[:id].gsub!(/./, 'A')

      # Validate it using the admin token
      result, error = admin_token.validate(token: default_token)

      result.must_equal false
      error.wont_be_nil
    end

  end
end