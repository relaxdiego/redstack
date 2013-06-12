require 'test_helper'

class IdentityRoleTests < MiniTest::Spec

  include RedStack::Identity::Models
  include CommonTestHelperMethods

  # Helper methods specific to these tests

  # Add 'em here!

  # Tests

  describe 'RedStack::Identity::Models::Role#[]' do

    def role
      Role.find(token: admin_scoped_token, connection: os.connection).first
    end

    it 'returns the role\'s id' do
      role[:id].wont_be_nil
    end

    it 'returns the role\'s name' do
      role[:name].wont_be_nil
    end

    # role[:description] can sometimes be nil

  end

  describe 'RedStack::Identity::Models::Role#find ' do

      it 'retrieves roles when a scoped token is provided' do
        roles = Role.find(token: admin_scoped_token, connection: os.connection)

        roles.must_be_instance_of Array
        roles.length.wont_be_nil
        roles.each { |p| p.must_be_instance_of Role }
      end

      it 'raises an error when a default token is provided' do
        find_method = lambda { Role.find(token: admin_default_token, connection: os.connection) }
        find_method.must_raise ArgumentError
        find_method.call rescue $!
      end

  end

end