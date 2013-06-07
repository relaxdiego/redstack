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


    def [](attr_name)
      data[attr_name.to_s] || data[self.class::ATTRIBUTES[attr_name][:key]]
    end
    alias :attributes :[]


    def delete!(options = {})
      if token.is_default?
        raise(RedStack::NotAuthorizedError.new(
                "Token with id #{ token[:id] } is not authorized to delete #{ resource_name }"
              ))
      end

      url  = token.get_endpoint(service: service_name, type: 'admin') + "/#{ resource_path }"
      mock_data_path = "#{ self.class.service_name }/#{ connection.build_url(url).path }"

      url += "/#{ self[:id] }"
      url += "?#{ options[:querystring] }" if options[:querystring]

      response = nil
      VCR.use_cassette(mock_data_path, record: :new_episodes, match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.delete do |req|
          req.headers['X-Auth-Token'] = token[:id]
          req.url url
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


    def self.attribute(attr_name, options = {})
      const_set('ATTRIBUTES', {}) unless defined?(self::ATTRIBUTES)
      attrs = self::ATTRIBUTES

      attrs[attr_name] = {}
      attrs[attr_name][:key] = (options[:key] || attr_name).to_s
      attrs[attr_name][:default] = options[:default] || nil
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
      token         = options[:token] || raise(ArgumentError.new('token not supplied'))
      connection    = options[:connection] || raise(ArgumentError.new('connection not supplied'))
      endpoint_type = options[:endpoint_type] || 'admin'

      url_or_path = ''
      if endpoint_type == 'admin'
        raise(ArgumentError.new("admin endpoint is not available to token with id #{ token['id'] }")) if token.is_default?
        url_or_path = token.get_endpoint(service: service_name, type: endpoint_type) + '/'
      end
      url_or_path += "#{ resource_path }#{ options[:querystring] ? '?' + options[:querystring] : '' }"

      mock_data_path = "#{ self.service_name }/#{ connection.build_url(url_or_path).path }"

      response = nil
      VCR.use_cassette(mock_data_path,
                       record: :new_episodes,
                       match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.get do |req|
          req.headers['X-Auth-Token'] = token[:id]
          req.url url_or_path
        end
      end

      case response.status
      when 200
        JSON.parse(response.body)[resource_name(plural: true)]
          .map { |r| new(data: { resource_name => r }, token: token, connection: connection) }
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

      if token.is_default?
        raise(RedStack::NotAuthorizedError.new(
                "Token with id #{ token[:id] } is not authorized to create #{ resource_name }"
              ))
      end

      url  = token.get_endpoint(service: service_name, type: 'admin') + "/#{ resource_path }"
      mock_data_path = "#{ self.service_name }/#{ connection.build_url(url).path }"

      response = nil
      VCR.use_cassette(mock_data_path, record: :new_episodes, match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.post do |req|
          req.headers['X-Auth-Token'] = token[:id]
          req.url url
          req.body = build_attributes(attributes).to_json
        end
      end
      response
    end

  end

end
end