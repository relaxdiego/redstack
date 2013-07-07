require 'test_helper'

class RedStack::Base::NamedParametersTest < MiniTest::Spec
  include RedStack::Base::NamedParameters

  describe 'RedStack::Base::NamedParameters' do
    
    describe '#validate_args' do
      
      it 'raises an error when required args are missing (flat array)' do
        m = lambda do 
              validate_args Hash.new, required: [:param1, :param2]
            end
        m.must_raise ArgumentError

        error = m.call rescue $!

        error.message.wont_be_nil
      end
      
      it 'passes when required args are present (flat array)' do
        options = { param1: 'something', param2: 'another'}
        
        result = validate_args options, required: options.keys
        
        result.must_equal true
      end
      
      
      it 'raises an error when required args are missing (2-axis array)' do
        m = lambda do 
              validate_args Hash.new, required: [[:param1], [:param2]]
            end
        m.must_raise ArgumentError

        error = m.call rescue $!

        error.message.wont_be_nil
      end
      
      
      it 'passes when either required args are present (2-axis array)' do
        options = { param1: 'something', param3: 'other' }
        
        result = validate_args options, required: [options.keys, [:param2]]
        
        result.must_equal true
      end
      
    end
    
  end
end