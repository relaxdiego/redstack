require 'test_helper'

class IdentityUserTests < MiniTest::Spec

  include RedStack::Identity::Models
  include CommonTestHelperMethods

  # Helper methods specific to these tests

  # Add 'em here!


  # Tests

  describe 'RedStack::Identity::Models::User::find' do

    it 'retrieves users when a valid scoped token is provided' do
      users = User.find(token: admin_scoped_token, connection: os.connection)

      users.must_be_instance_of Array
      users.length.wont_be_nil
      users.each { |u| u.must_be_instance_of User }
    end


    it 'raises an error when an unscoped token is provided' do
      find_method = lambda { User.find(token: non_admin_default_token, connection: os.connection) }
      find_method.must_raise ArgumentError
      find_method.call rescue $!
    end


    it 'raises an error a scoped token without the requisite permission is provided' do
      find_method = lambda { User.find(token: non_admin_scoped_token, connection: os.connection) }
      find_method.must_raise RedStack::NotAuthorizedError
      error = find_method.call rescue $!
      error.message.wont_be_nil
    end

  end


  describe 'RedStack::Identity::Models::User::create' do
    it 'creates a user when an authorized token is provided' do
      attributes = {
        username: 'redstacknewuser',
        email:    'redstacknewuser@gmail.com',
        enabled:  true,
        password: 'secrete'
      }

      user = User.create(
               token:      admin_scoped_token,
               connection: os.connection,
               attributes: attributes
             )

      # The querystring argument ensures that Faraday doesn't match against the
      # User.find query made in other tests which will not return this user.
      users = User.find(
                token:        admin_scoped_token,
                connection:   os.connection,
                querystring: 'after_user_create'
              )
      users.find{ |u| u[:username] == attributes[:username] }.wont_be_nil "User '#{ attributes[:username] }' was not created"

      # Cleanup
      user.delete!
    end
  end
end