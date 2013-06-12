require 'test_helper'

class VersionTests < MiniTest::Spec

  describe 'RedStack::VERSION' do

    it 'must be defined' do
      RedStack::VERSION.wont_be_nil
    end

  end

end