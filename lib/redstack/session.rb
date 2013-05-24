module RedStack

  class Session
    attr_accessor :access,
                  :api_version,
                  :host
    
    attr_reader   :identity_service,
                  :stub_openstack

    def initialize(options = {})
      @api_version    = options[:api_version]
      @host           = options[:host]
      @stub_openstack = options[:stub_openstack] || false
      
      if stub_openstack
        VCR.configure do |c|
          c.cassette_library_dir = File.expand_path("../../../test/fixtures/openstack", __FILE__)
          c.hook_into :faraday
        end
      end
    end
    
    def authenticate(credentials = {})
      response = nil
      
      VCR.use_cassette("#{ api_version }_authentication", record: :new_episodes, match_requests_on: [:body]) do
        response = connection.post do |req|
          req.url 'tokens'
          req.body = {
            auth: {
              passwordCredentials: {
                username: credentials[:username],
                password: credentials[:password],
                tenant: ''
              }
            }
          }.to_json
        end
      end
      
      case response.status
      when 200
        @access = Access.new(response.body)
      when 401
        @access = nil
      end
    end
    
    def authenticated?
      !access.nil?
    end
    
    def uri(path=nil)
      URI.join(host, api_version)
    end
    
    private
    
    def connection
      @connection ||= Faraday::Connection.new(:url => uri.to_s) do |c|
        c.headers['Content-Type'] = 'application/json'
        c.adapter Faraday.default_adapter
      end
    end
    
  end # class Session

end # module RedStack
