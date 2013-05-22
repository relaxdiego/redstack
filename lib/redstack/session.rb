module RedStack

  class Session
    attr_accessor :host, :api_version, :access
    
    def initialize(options = {})
      @host        = options[:host]
      @api_version = options[:api_version]
    end
    
    def authenticate(credentials = {})
      loc     = uri('tokens')
      server  = Net::HTTP.new(loc.host, loc.port)
      auth_data = {
        "auth" => {
          "passwordCredentials" => {
            "username" => "admin",
            "password" => "password"
          }
        }
      }.to_json
      content_type = {'Content-Type' => 'application/json'}
      response     = server.post(loc.path, auth_data, content_type)
      @access       = Access.new(response.body)
      
      # Response can be:
      # ============================================
      # POST /v2.0/tokens
      #   Headers:
      #     * content-type: application/json
      #     * accept: */*
      #     * user-agent: Ruby
      #     * connection: close
      #     * host: localhost:3000
      #     * content-length: 75
      #     * cache-control: no-cache
      #   Body:
      #     {"auth":{"passwordCredentials":{"username":"admin","password":"password"}}}
      # --------------------------------------------
      # Response code: 200
      #   Headers:
      #     * vary: X-Auth-Token
      #     * content-type: application/json
      #     * content-length: 329
      #     * date: Wed, 22 May 2013 08:11:26 GMT
      #     * connection: close
      #   Content (329 bytes): {"access": {"token": {"issued_at": "2013-05-22T08:11:26.389895", "expires": "2013-05-23T08:11:26Z", "id": "1fc3da465dc143d6b20546c2a502de74"}, "serviceCatalog": [], "user": {"username": "admin", "roles_links": [], "id": "0ae8dad9d5ba4273bae88be20325a07b", "roles": [], "name": "admin"}, "metadata": {"is_admin": 0, "roles": []}}}
    end
    
    def uri(path=nil)
      if path
        URI.join(host, api_version + "/", path)
      else
        URI.join(host, api_version)
      end
    end
  end

end
