require 'test_helper'

class VersionTest < MiniTest::Spec

  it 'must be defined' do
    RedStack::VERSION.wont_be_nil
  end

end