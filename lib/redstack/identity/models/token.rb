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
      @services      = options[:data]['access']['serviceCatalog']
      options[:data] = options[:data]['access']
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
      self[:project].nil? unless error
    end
    alias :is_unscoped? :is_default?
    
    
    def is_scoped?
      !is_default?
    end
    
    
    def validate(options={})
      if self.is_default?
        raise RedStack::NotAuthorizedError.new("token with id #{ self[:id] } is not authorized to validate other tokens")
      end

      token     = options[:token] || raise(ArgumentError.new('token to validate was not supplied'))
      stub_path = connection.url_prefix.path + '/' + resource_path

      url  = self.get_endpoint(service: service_name, type: 'admin') + "/#{ resource_path }"
      mock_data_path = connection.build_url(url).path
      url += "/#{ token[:id] }"

      response = nil
      VCR.use_cassette(mock_data_path, record: :new_episodes, match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.get do |req|
          req.headers['X-Auth-Token'] = self[:id]
          req.url url
        end
      end

      case response.status
      when 200
        true
      else
        return false, JSON.parse(response.body)['error']
      end
    end
    
    
    private
    
    def self.build_attributes(attributes)
      body = {}
      
      body[:auth] = if attributes.has_key? :username
                      {
                        passwordCredentials: {
                          username: attributes[:username],
                          password: attributes[:password]
                        },
                        tenantName: attributes[:tenant] || attributes[:project] || ''
                      }
                    else
                      {
                        token: {
                          id: attributes[:token][:id]
                        },
                        tenantName: attributes[:tenant] || attributes[:project] || ''
                      }
                    end
      body
    end

    def self.do_create(options)
      attributes = options[:attributes] || raise(ArgumentError.new('attributes not supplied'))
      connection = options[:connection] || raise(ArgumentError.new('connection not supplied'))
      stub_path  = connection.url_prefix.path + '/' + resource_path

      response = nil
      VCR.use_cassette(stub_path, record: :new_episodes, match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.post do |req|
          req.url resource_path
          req.body = build_attributes(attributes).to_json
        end
      end
      
      response
    end
                
  end # class Token

end # module Models
end # module Identity
end # module RedStack
  
