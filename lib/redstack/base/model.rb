module RedStack
module Base
  
  class Model

    attr_reader :connection,
                :data,
                :error,
                :token


    def initialize(options = {})
      @data       = (options[:data] || {})[self.class.resource_name]
      @error      = options[:error]
      @connection = options[:connection]
      @token      = options[:token]
    end

    
    def [](key)
      data[key]
    end
    alias :attributes :[]


    def delete!(options = {})
      if token.get_endpoint(service: service_name, type: 'admin').nil?
        raise RedStack::NotAuthorizedError.new('token is not authorized to delete the project')
      end
      
      stub_path = connection.url_prefix.path + '/' + resource_path
            
      response = nil
      VCR.use_cassette(stub_path, record: :new_episodes, match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.delete do |req|
          req.headers['X-Auth-Token'] = token.id
          req.url token.get_endpoint(service: service_name, type: 'admin') + "/#{ resource_path }/#{ self['id'] }"
        end
      end

      case response.status
      when 204
        true
      when 401, 403
        raise(RedStack::NotAuthorizedError.new(JSON.parse(response.body)['error']['message']))
      else
        raise(RedStack::UnexpectedError.new(JSON.parse(response.body)['error']['message']))
      end
    end
  
    
    def resource_path
      self.class.resource_path
    end
    
    
    def self.attribute(name, options = {})
      const_set('ATTRIBUTES', {}) unless defined?(self::ATTRIBUTES)
      attrs = self::ATTRIBUTES
      
      attrs[name] = {}
      attrs[name][:key] = options[:key] || name
      attrs[name][:default] = options[:default] || nil
      
      unless options[:read] == false
        define_method(name) do
          data[self.class::ATTRIBUTES[name][:key].to_s]
        end
      end
    end
      
    
    def self.create(options = {})
      response = do_create(options)

      case response.status
      when 200
        new(data: JSON.parse(response.body), token: options[:token], connection: options[:connection])
      when 401, 403
        raise(RedStack::NotAuthorizedError.new(JSON.parse(response.body)['error']['message']))
      else
        raise(RedStack::UnexpectedError.new(JSON.parse(response.body)['error']['message']))
      end
    end
    
    
    def self.find(options = {})
      admin_token   = options[:token] || raise(ArgumentError.new('token not supplied'))
      connection    = options[:connection] || raise(ArgumentError.new('connection not supplied'))
      stub_path     = connection.url_prefix.path + '/' + resource_path
      endpoint_type = options[:endpoint_type] || 'admin'
      
      path = nil
      if endpoint_type == 'admin'
        raise(ArgumentError.new('token is unscoped')) if admin_token.is_default?
        path = admin_token.get_endpoint(service: service_name, type: endpoint_type) + "/#{ resource_path }?#{ options[:querystring] }"
      else
        path = "#{ resource_path }?#{ options[:querystring] }"
      end
      
      response = nil
      VCR.use_cassette(stub_path, record: :new_episodes, match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.get do |req|
          req.headers['X-Auth-Token'] = admin_token.id
          req.url path
        end
      end

      case response.status
      when 200
        JSON.parse(response.body)[resource_name(plural: true)]
          .map { |r| new(data: { resource_name => r }, token: admin_token, connection: connection) }
      when 401, 403
        raise(RedStack::NotAuthorizedError.new(JSON.parse(response.body)['error']['message']))
      end
    end
    
    
    def self.resource(name)
      const_set('RESOURCE_NAME', name.to_s.downcase)
    end
    
    
    def self.resource_name(options = {})
      name = defined?(self::RESOURCE_NAME) ? self::RESOURCE_NAME : self.name.split('::').last.downcase
      options[:plural] ? name + 's' : name
    end
        
    
    def self.resource_path
      resource_name plural: true
    end
    
    
    def self.service(name)
      const_set('SERVICE_NAME', name.to_s)
    end
    
    
    def self.service_name
      defined?(self::SERVICE_NAME) ? self::SERVICE_NAME : self.name.split('::')[1].downcase
    end
    
    
    def service_name
      self.class.service_name
    end
    
    private
    
    def error=(val)
      @error = val
    end


    def self.build_attributes(values)
      attrs = self::ATTRIBUTES
      value = {}
      
      attrs.keys.each do |name|
        value[attrs[name][:key]] = (values[name] || attrs[name][:default]) unless name == :id and values[name].nil?
      end
      
      { resource_name => value }
    end

    
    def self.do_create(options)
      token      = options[:token]      || raise(ArgumentError.new('token not supplied'))
      connection = options[:connection] || raise(ArgumentError.new('connection not supplied'))
      attributes = options[:attributes] || raise(ArgumentError.new('attributes not supplied'))
      stub_path  = connection.url_prefix.path + '/' + resource_path
      
      raise(ArgumentError.new('token is unscoped')) if token.is_default?
      
      response = nil
      VCR.use_cassette(stub_path, record: :new_episodes, match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.post do |req|
          req.headers['X-Auth-Token'] = token.id
          req.url token.get_endpoint(service: service_name, type: 'admin') + "/#{ resource_path }"
          req.body = build_attributes(attributes).to_json
        end
      end
      response
    end
    
  end

end
end