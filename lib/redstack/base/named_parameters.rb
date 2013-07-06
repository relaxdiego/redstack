module RedStack
module Base

  module NamedParameters
    
    private
    
    def validate_args(args, options={})
      options[:required].each do |required|
        unless args.keys.include? required
          raise ArgumentError.new("Missing argument #{required}")
        end
      end
    end
    
  end

end
end
