require 'test_helper'

class RedStack::Identity::Clients::V2_0Test < MiniTest::Spec
  include RedStack::Identity

  describe 'RedStack::Identity::Clients::V2_0' do

    def conn
      Connection.new host: RedStack::TestConfig[:identity_host], api_version: 'v2.0'
    end
    
    describe '#api_version' do
      
      it 'returns v2.0' do
        conn.api_version.must_equal 'v2.0'
      end
      
    end # describe '#api_version'

    describe '#create_token' do

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
