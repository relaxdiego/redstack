require_relative '../../test_helper'
 
describe 'RedStack VERSION' do
 
  it 'must be defined' do
    RedStack::VERSION.wont_be_nil
  end
 
end