module RedStack
module Mappers
  
  class TenantMapper
    
    attr_reader :session,
                :tenants
    
    def initialize(session)
      @session = session
    end
    
    def get_all
      response = nil
      
      VCR.use_cassette("#{ session.api_version }_tenants", record: :new_episodes, match_requests_on: [:body]) do
        response = session.connection.get do |req|
          req.url 'tenants'
          req.headers['X-Auth-Token'] = session.access['token']['id']
        end
      end
      
      case response.status
      when 200
        @tenants = JSON.parse(response.body)['tenants']
        self
      when 401
        nil
      end
    end
    
    def length
      @tenants.length
    end
    
  end # class TenantMapper

end # module Mappers
end # module RedStack