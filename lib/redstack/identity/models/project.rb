module RedStack
module Identity
module Models
    
  class Project
    
    attr_reader :data,
                :session

    def self.create(options={})
      response   = nil
      attributes = { tenant: options[:attributes] }.to_json
      token      = options[:token] || raise(ArgumentError.new('token not supplied'))
      connection = options[:connection] || raise(ArgumentError.new('connection not supplied'))
      path       = connection.url_prefix.path + '/tenants'

      VCR.use_cassette(path, record: :all, match_requests_on: [:headers, :body, :method]) do
        response = connection.post do |req|
          req.url path
          req.headers['X-Auth-Token'] = token
          req.body = attributes
        end
      end

      case response.status
      when 200
        new(data: JSON.parse(response.body)['tenant'])
      when 401
        nil
      end
    end

    
    def self.find(options={})
      response   = nil
      token      = options[:token] || raise(ArgumentError.new('token not supplied'))
      connection = options[:connection] || raise(ArgumentError.new('connection not supplied'))
      path       = connection.url_prefix.path + '/tenants'
      
      VCR.use_cassette(path, record: :new_episodes, match_requests_on: [:body, :method]) do
        response = connection.get do |req|
          req.url path
          req.headers['X-Auth-Token'] = token
        end
      end
    
      case response.status
      when 200
        JSON.parse(response.body)['tenants'].map { |p| new(data: p) }
      when 401
        nil
      end
    end
    
    def initialize(options={})
      @data = options[:data]
      @session = options[:session]
    end
    
    def [](key)
      data[key]
    end
            
  end # class Project

end # module Models
end # module Identity
end # module RedStack
  
