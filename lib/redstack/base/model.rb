module RedStack
module Base

  class Model

    attr_reader :connection,
                :data,
                :error,
                :token


    def initialize(options = {})
      @data       = (options[:data] || {})[self.class.resource_name]
      @dirty      = false
      @error      = options[:error]
      @connection = options[:connection]
      @token      = options[:token]
    end


    def [](attr_name)
      validate_attr_name(attr_name)
      data[self.class::ATTRIBUTES[attr_name.to_sym][:key]]
    end
    alias :attributes :[]


    def []=(attr_name, value)
      validate_attr_name(attr_name)
      @dirty = true unless data[self.class::ATTRIBUTES[attr_name.to_sym][:key]] == value
      data[self.class::ATTRIBUTES[attr_name.to_sym][:key]] = value
    end


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

    def dirty?
      @dirty
    end

    def resource_path
      self.class.resource_path
    end


    def self.attribute(attr_name, options = {})
      const_set('ATTRIBUTES', {}) unless defined?(self::ATTRIBUTES)
      attrs = self::ATTRIBUTES
      attr_name = attr_name.to_sym

      attrs[attr_name] = {}
      attrs[attr_name][:key] = (options[:key] || attr_name).to_s
      attrs[attr_name][:default] = options[:default] || nil
    end


    def save!
      if token.is_default?
        raise(RedStack::NotAuthorizedError.new(
                "Token with id #{ token[:id] } is not authorized to save #{ resource_name }"
              ))
      end

      url  = token.get_endpoint(service: service_name, type: 'admin') + "/#{ resource_path }"
      mock_data_path = "#{ self.class.service_name }/#{ connection.build_url(url).path }"

      url += "/#{ self[:id] }"

      response = nil
      VCR.use_cassette(mock_data_path, record: :new_episodes, match_requests_on: [:uri, :headers, :body, :method]) do
        response = connection.post do |req|
          req.headers['X-Auth-Token'] = token[:id]
          req.url url
          req.body = self.class.build_attributes(data).to_json
        end
      end

      case response.status
      when 200
        @dirty = false
        true
      when 401, 403
        raise(RedStack::NotAuthorizedError.new(JSON.parse(response.body)['error']['message']))
      else
        raise(RedStack::UnexpectedError.new(JSON.parse(response.body)['error']['message']))
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


    def self.build_attributes(input_values)
      attrs = self::ATTRIBUTES
      output_values = {}
      attrs.keys.each do |name|
        next if name == :id

        output_values[attrs[name][:key]] =
            if input_values[name].nil? and input_values[attrs[name][:key]].nil?
              attrs[name][:default]
            elsif input_values[name].nil?
              input_values[attrs[name][:key]]
            else
              input_values[name]
            end
      end
      { resource_name => output_values }
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


    def validate_attr_name(attr_name)
      if self.class::ATTRIBUTES[attr_name.to_sym].nil?
        raise(ArgumentError.new(
          "#{ attr_name.to_s } is unknown. Available keys are #{ self.class::ATTRIBUTES.keys.join(', ') }"
        ))
      end
      true
    end

  end

end
end