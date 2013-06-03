module RedStack
module Identity
module Models
    
  # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Token_Operations.html
  class Token 
    
    RESOURCE_PATH = 'tokens'
    
    attr_reader :data,
                :error
  
    def initialize(options={})
      @data  = options[:data]
      @error = options[:error]
    end
    
    def [](key)
      data[key]
    end
        
    def id
      data['token']['id'] unless error
    end
    
    def get_endpoint(options = {})
      return nil if (is_default? || error)
      raise(ArgumentError.new('service not supplied')) if options[:service].nil?
      raise(ArgumentError.new('endpoint type not supplied')) if options[:type].nil?
      
      services = {
        'identity' => 'keystone'
      }
      
      types = {
        'admin'    => 'adminURL',
        'public'   => 'publicURL',
        'internal' => 'internalURL'
      }
      
      service = services[options[:service]]
      type    = types[options[:type]]
      data['serviceCatalog'].find { |s| s['name'] == service }['endpoints'][0][type]
    end
    
    def is_default?
      data['token']['tenant'].nil? unless error
    end
    alias :is_unscoped? :is_default?
    
    def is_scoped?
      !is_default?
    end

    def self.create(options = {})
      token         = options[:token] || ''
      connection    = options[:connection] || raise(ArgumentError.new('connection not supplied'))
      resource_path = self::RESOURCE_PATH
      stub_path     = connection.url_prefix.path + '/' + resource_path
      body          = {}
            
      body[:auth] = if options.has_key? :username
                      {
                        passwordCredentials: {
                          username: options[:username],
                          password: options[:password],
                          tenant:   options[:tenant] || options[:project] || ''
                        }
                      }
                    else
                      {
                        token: {
                          id: token.id
                        },
                        tenantName: options[:tenant] || options[:project] || ''
                      }
                    end

      response = nil
      VCR.use_cassette(stub_path, record: :new_episodes, match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.post do |req|
          req.url resource_path
          req.body = body.to_json
        end
      end
      
      case response.status
      when 200
        new data: JSON.parse(response.body)['access']
      else
        new error: JSON.parse(response.body)['error']
      end
    end
    
    def validate!(options={})
      admin_token   = options[:admin_token] || raise(ArgumentError.new('admin token not supplied'))
      connection    = options[:connection] || raise(ArgumentError.new('connection not supplied'))
      resource_path = self.class::RESOURCE_PATH
      stub_path     = connection.url_prefix.path + '/' + resource_path

      response = nil
      VCR.use_cassette(stub_path, record: :new_episodes, match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.get do |req|
          req.headers['X-Auth-Token'] = admin_token.id
          req.url admin_token.get_endpoint(service: 'identity', type: 'admin') + "/#{ resource_path }/#{ id }"
        end
      end

      case response.status
      when 200
        true
      else
        self.error = JSON.parse(response.body)['error']
        false
      end
    end
    
    private
    
    def error=(val)
      @error = val
    end
            
  end # class Token

end # module Models
end # module Identity
end # module RedStack
  
