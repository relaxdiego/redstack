module RedStack
module Identity

  class Connection

    def initialize(options={})
      host        = extract_or_raise(options, :host)
      api_version = extract_or_raise(options, :api_version)

      include_client_for(options[:api_version])
    end

    def create_token(options={})
      if options[:token]
        token = options[:token]
      else
        username = extract_or_raise(options, :username)
        password = extract_or_raise(options, :password)
      end

      Token.new
    end

    private

    def extract_or_raise(args, name)
      args[name] || (raise ArgumentError.new("Missing argument #{name}"))
    end

    # Loads the client methods that know how to
    # talk to the specified OpenStack API version
    def include_client_for(version)
      begin
        client = "RedStack::Identity::Clients::#{version.gsub('.', '_').upcase}".constantize
        extend client
      rescue NameError => e
        raise RedStack::UnknownApiVersionError.new("Identity API version #{version} is undefined")
      end
      true
    end
    
  end

end
end