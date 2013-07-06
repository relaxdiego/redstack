require 'test_helper'

class RedStack::Identity::ConnectionTest < MiniTest::Spec
  include RedStack::Identity

  describe 'RedStack::Identity::Connection' do

    describe '#new' do

      it 'returns a Connection instance' do
        ks = Connection.new host: 'http://os.com', api_version: 'v2.0'

        ks.class.must_equal RedStack::Identity::Connection
      end


      it 'raises an error when the host parameter is missing' do
        initializer = lambda { Connection.new api_version: 'v2.0' }
        initializer.must_raise ArgumentError

        error = initializer.call rescue $!

        error.message.wont_be_nil
      end


      it 'raises an error when the api_version parameter is missing' do
        initializer = lambda { Connection.new host: 'http://www.example.org' }
        initializer.must_raise ArgumentError

        error = initializer.call rescue $!

        error.message.wont_be_nil
      end


      it 'raises an error when api_version is unknown' do
        initializer = lambda { Connection.new host: 'http://os.com', api_version: 'v9999.0' }
        initializer.must_raise RedStack::UnknownApiVersionError

        error = initializer.call rescue $!

        error.message.wont_be_nil
      end

    end # describe '#new'

  end

end
