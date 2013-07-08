module RedStack
module Identity

  class Connection

    attr_reader :token

    def initialize(options={})
      host        = extract_or_raise(options, :host)
      api_version = extract_or_raise(options, :api_version)

      init_connection(host)
      include_client_for(options[:api_version])
    end

    private

    def connection
      # Initialized via init_connection which is called by initialize
      @connection
    end

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

    def init_connection(host)
      @connection = Faraday::Connection.new(:url => host.to_s) do |c|
        c.headers['Content-Type'] = 'application/json'
        c.adapter Faraday.default_adapter
      end
    end
    
    def token=(val)
      raise ArgumentError.new('Object must be an instance of Token') unless val.class == Resources::Token
      @token = val
    end
  end

end
end