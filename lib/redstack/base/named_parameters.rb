module RedStack
module Base

  module NamedParameters
    
    private
    
    def validate_args(args, options={})
      required = options[:required]
      
      groups = if required.find {|e| e.class == Array }
                 required.map { |e| e.class == Array ? e : [e] }
               else
                 [required]
               end

      errors = []
      
      groups.each_with_index do |group, index|
        group.each do |required|
          errors[index] = required unless args.keys.include?(required)
          break if errors[index]
        end
      end

      if errors.length > 0 and errors.none?{|e| e.nil? }
        raise ArgumentError.new("Missing argument #{errors.last}")
      end
      true
    end
    
  end

end
end
