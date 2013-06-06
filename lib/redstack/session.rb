module RedStack

  class Session
    attr_accessor :api_version,
                  :host
    
    attr_reader   :identity_service,
                  :stub_openstack

    def initialize(options = {})
      @api_version = options[:api_version]
      @host        = options[:host]
      @tokens      = {}
    end
    
    def authenticate(options = {})
      begin
        token = Identity::Models::Token.create(
                  connection: connection,
                  attributes: {
                    username: options[:username], 
                    password: options[:password] 
                  }
                )
      
        if token.is_default?
          @tokens[:default] = token
        end
      rescue RedStack::NotAuthorizedError => e
        @tokens[:default] = nil
      end      
    end
    
    def authenticated?
      !tokens[:default].nil?
    end
    
    def tokens
      @tokens
    end
    
    def uri(path=nil)
      URI.join(host, api_version)
    end
    
    def connection
      @connection ||= Faraday::Connection.new(:url => uri.to_s) do |c|
        c.headers['Content-Type'] = 'application/json'
        c.adapter Faraday.default_adapter
      end
    end
    
  end # class Session

end # module RedStack
