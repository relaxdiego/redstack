require 'test_helper'

class RedStack::Identity::Clients::V2_0Test < RedStack::TestBase
  include RedStack::Identity
  include RedStack::Identity::Resources

  describe 'RedStack::Identity::Clients::V2_0' do

    def conn
      Connection.new host: RedStack::TestConfig[:identity_host], api_version: 'v2.0'
    end

    def admin_conn
      c = conn
      c.authenticate username: 'admin', password: 'password', project: 'admin'
      c
    end

    def non_admin_conn
      c = conn
      c.authenticate username: 'validuser', password: 'validpassword', project: 'validproject'
      c
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


    describe '#token' do

      it 'stores the last token created by authenticate' do
        c     = conn
        token = c.authenticate username: 'validuser', password: 'validpassword'

        c.token.must_equal token
      end

    end # describe '#token'


    describe '#validate_token' do

      it 'returns true if token is valid' do
        token = conn.authenticate username: 'validuser', password: 'validpassword'

        result = admin_conn.validate_token token: token

        result.must_equal true
      end

      it 'returns true if token belongs to the specified project' do
        token = conn.authenticate username: 'validuser', password: 'validpassword', project: 'validproject'

        result = admin_conn.validate_token token: token, project: token[:project][:name]

        result.must_equal false
      end

      it 'returns false if token does not belong to the specified project' do
        token = conn.authenticate username: 'validuser', password: 'validpassword'

        result = admin_conn.validate_token token: token, project: 'myproject'

        result.must_equal false
      end

      it 'returns false if the token is invalid' do
        token = Token.new(%Q{
           {"access": {"token": {"issued_at": "2013-07-08T03:51:43.718569",
           "expires": "#{ Time.now.year + 1 }-07-09T03:51:43Z", "id": "zzzzzzzzzzzzzzzzzzz"},
           "serviceCatalog": [], "user": {"username": "validuser", "roles_links": [],
           "id": "24655bbc441843efb44c5cf058978df6", "roles": [], "name": "validuser"},
           "metadata": {"is_admin": 0, "roles": []}}}
         })

        result = admin_conn.validate_token token: token

        result.must_equal false
      end

      it 'raises an error when the user is not authorized to validate tokens' do
        token = conn.authenticate username: 'validuser', password: 'validpassword'
        m = lambda { non_admin_conn.validate_token token: token }

        m.must_raise RedStack::NotAuthorizedError
        error = m.call rescue $!

        error.message.wont_be_nil
      end

    end # describe '#validate_token'


  end

end
