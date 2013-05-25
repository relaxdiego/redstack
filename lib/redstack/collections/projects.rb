module RedStack
module Collections

  class Projects

    attr_reader :session,
                :items
    
    def initialize(session)
      @session = session
    end
    
    def find_all
      response = nil
    
      VCR.use_cassette("#{ session.api_version }_tenants", record: :new_episodes, match_requests_on: [:body]) do
        response = session.connection.get do |req|
          req.url 'tenants'
          req.headers['X-Auth-Token'] = session.access['token']['id']
        end
      end
    
      case response.status
      when 200
        @data = JSON.parse(response.body)
        self
      when 401
        nil
      end
    end
    
    def items
      @data['tenants']
    end
    
    def length
      items.length
    end

  end # class Projects

end # module Collections
end # module RedStack