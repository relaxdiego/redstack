module RedStack
module Identity

  class Connection
    include RedStack::Base::NamedParameters

    def initialize(options={})
      validate_args options, required: [:host, :api_version]

      include_client_for(options[:api_version])
    end

    def create_token(options={})
      validate_args options, required: [[:username, :password], [:token]]

      Token.new
    end

    private

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