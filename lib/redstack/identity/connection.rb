module RedStack
module Identity

  class Connection
    include RedStack::Base::NamedParameters
    
    def initialize(options={})
      validate_args options, required: [:host, :api_version]
      
      unless load_api_library(options[:api_version])
        raise RedStack::UnknownApiVersionError.new("API version #{options[:api_version]} is undefined")
      end
    end
    
    
    private
    
    def load_api_library(version)
      Pathname.new(__FILE__).join('..', 'api_lib', "#{version}.rb")
    end
        
  end

end
end