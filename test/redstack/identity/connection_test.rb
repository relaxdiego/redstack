require 'test_helper'

class RedStack::Identity::ConnectionTest < MiniTest::Spec
  include RedStack::Identity

  describe 'RedStack::Identity::Connection' do
    
    it 'can be initialized' do
      ks = Connection.new host: 'http://os.com', api_version: 'v2.0'
      
      ks.wont_be_nil
    end
    
    it 'raises an error when initialized and host and api_version are missing' do
      initializer = lambda { Connection.new }
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

  end

end
