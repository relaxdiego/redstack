require 'test_helper'

class RedStack::VersionTest < MiniTest::Spec

  describe 'RedStack::VERSION' do

    it 'must be defined' do
      RedStack::VERSION.wont_be_nil
    end

    it 'must be a string' do
      RedStack::VERSION.class.must_equal String
    end

  end

end
