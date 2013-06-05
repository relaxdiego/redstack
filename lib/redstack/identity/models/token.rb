module RedStack
module Identity
module Models
    
  # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Token_Operations.html
  class Token < RedStack::Base::Model
    
    attribute :id
    attribute :issued_at
    attribute :expires
    attribute :project, key: 'tenant'
    
    def initialize(options = {})
      @services = options[:services]
      super options
    end
                
    def get_endpoint(options = {})
      return nil if (is_default? || error)
      raise(ArgumentError.new('service not supplied')) if options[:service].nil?
      raise(ArgumentError.new('endpoint type not supplied')) if options[:type].nil?

      types = {
        'admin'    => 'adminURL',
        'public'   => 'publicURL',
        'internal' => 'internalURL'
      }
      
      @services.find { |s| s['type'] == options[:service] }['endpoints'][0][types[options[:type]]]
    end
    
    
    def is_default?
      project.nil? unless error
    end
    alias :is_unscoped? :is_default?
    
    
    def is_scoped?
      !is_default?
    end


    def self.create(options = {})
      attributes = options[:attributes] || raise(ArgumentError.new('attributes not supplied'))
      connection = options[:connection] || raise(ArgumentError.new('connection not supplied'))
      stub_path  = connection.url_prefix.path + '/' + resource_path
      body       = {}
            
      body[:auth] = if attributes.has_key? :username
                      {
                        passwordCredentials: {
                          username: attributes[:username],
                          password: attributes[:password],
                          tenant:   attributes[:tenant] || attributes[:project] || ''
                        }
                      }
                    else
                      {
                        token: {
                          id: attributes[:token].id
                        },
                        tenantName: attributes[:tenant] || attributes[:project] || ''
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
        body = JSON.parse(response.body)
        self.new data: body['access']['token'], services: body['access']['serviceCatalog']
      else
        self.new error: JSON.parse(response.body)['error']
      end
    end
    
    
    def validate!(options={})
      admin_token   = options[:admin_token] || raise(ArgumentError.new('admin token not supplied'))
      connection    = options[:connection] || raise(ArgumentError.new('connection not supplied'))
      stub_path     = connection.url_prefix.path + '/' + resource_path
      
      raise(ArgumentError.new('token is unscoped')) if admin_token.is_default?

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
                
  end # class Token

end # module Models
end # module Identity
end # module RedStack
  
