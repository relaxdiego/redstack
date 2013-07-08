require 'test_helper'

class RedStack::Identity::Clients::V2_0Test < RedStack::TestBase
  include RedStack::Identity
  include RedStack::Identity::Resources

  describe 'RedStack::Identity::Clients::V2_0' do

    def conn
      Connection.new host: RedStack::TestConfig[:identity_host], api_version: 'v2.0'
    end


    describe '#api_version' do

      it 'returns v2.0' do
        conn.api_version.must_equal 'v2.0'
      end

    end # describe '#api_version'


    describe '#authenticate' do

      it 'raises an error when username, password, and token are missing' do
        m = lambda { conn.authenticate }
        m.must_raise ArgumentError

        error = m.call rescue $!

        error.message.wont_be_nil
      end


      it 'creates a token when username and password are provided' do
        token = conn.authenticate username: 'validuser', password: 'validpassword'

        token.class.must_equal Token
      end


      it 'creates a token when another token is provided' do
        token = conn.authenticate username: 'validuser', password: 'validpassword'

        token = conn.authenticate token: token

        token.class.must_equal Token
      end
      
      
      it 'creates a scoped token when username, password, and project are provided' do
        token = conn.authenticate username: 'validuser', password: 'validpassword', project: 'validproject'

        token.default?.must_equal false
      end


      it 'creates a scoped token when token and project are provided' do
        token = conn.authenticate username: 'validuser', password: 'validpassword'

        token = conn.authenticate token: token, project: 'validproject'

        token.default?.must_equal false
      end

    end # describe '#authenticate'

  end

end
