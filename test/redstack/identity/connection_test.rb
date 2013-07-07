require 'test_helper'

class RedStack::Identity::ConnectionTest < MiniTest::Spec
  include RedStack::Identity

  describe 'RedStack::Identity::Connection' do
    
    def identity_host
      RedStack::TestConfig[:identity_host]
    end

    describe '::new' do

      it 'creates a Connection instance' do
        ks = Connection.new host: identity_host, api_version: 'v2.0'

        ks.class.must_equal Connection
      end


      it 'raises an error when host is missing' do
        initializer = lambda { Connection.new api_version: 'v2.0' }
        initializer.must_raise ArgumentError

        error = initializer.call rescue $!

        error.message.wont_be_nil
      end


      it 'raises an error when api_version is missing' do
        initializer = lambda { Connection.new host: identity_host }
        initializer.must_raise ArgumentError

        error = initializer.call rescue $!

        error.message.wont_be_nil
      end


      it 'raises an error when api_version is unknown' do
        initializer = lambda { Connection.new host: identity_host, api_version: 'v9999.0' }
        initializer.must_raise RedStack::UnknownApiVersionError

        error = initializer.call rescue $!

        error.message.wont_be_nil
      end

    end # describe '::new'


    describe '#create_token' do

      def conn
        Connection.new host: identity_host, api_version: 'v2.0'
      end

      it 'raises an error when username, password, and token are missing' do
        m = lambda { conn.create_token }
        m.must_raise ArgumentError

        error = m.call rescue $!

        error.message.wont_be_nil
      end


      it 'creates a token when username and password are provided' do
        token = conn.create_token username: 'validuser', password: 'validpassword'

        token.class.must_equal Token
      end


      it 'creates a token when another token is provided' do
        token = conn.create_token token: 'sometokenvaluehere'

        token.class.must_equal Token
      end

    end # describe '#create_token'

  end

end
