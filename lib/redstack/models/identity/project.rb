module RedStack
module Models
module Identity
    
  class Project
    
    attr_reader :data,
                :session
    
    def self.find(options={})
      response = nil
      session = options[:session]
    
      VCR.use_cassette("#{ session.api_version }_project_find", record: :new_episodes, match_requests_on: [:body]) do
        response = session.connection.get do |req|
          req.url 'tenants'
          req.headers['X-Auth-Token'] = session.access['token']['id']
        end
      end
    
      case response.status
      when 200
        JSON.parse(response.body)['tenants'].map { |p| new(data: p, session: session) }
      when 401
        nil
      end
    end
    
    def initialize(options={})
      @data = options[:data]
      @session = options[:session]
    end
    
    def create(attributes={})
      response = nil
    
      VCR.use_cassette("#{ session.api_version }_project_create", record: :new_episodes) do
        response = session.identity_service.admin_endpoint.post do |req|
          req.url 'tenants'
          req.headers['X-Auth-Token'] = session.access['token']['id']
        end
      end
    
      case response.status
      when 200
        JSON.parse(response.body)['tenants'].map { |p| new(data: p, session: session) }
      when 401
        nil
      end
    end
        
  end # class Project

end # module Identity
end # module Models
end # module RedStack
  
