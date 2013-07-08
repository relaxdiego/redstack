module RedStack
module Identity
module Clients

  module V2_0

    def api_version
      'v2.0'
    end

    #==================
    # TOKEN OPERATIONS
    #==================
    
    def authenticate(options)
      create_token(options)
    end

    def create_token(options={})
      if options[:token]
        token     = options[:token]
        auth_data = {
                      token: { id: token[:id] }
                    }
      else
        username  = extract_or_raise(options, :username)
        password  = extract_or_raise(options, :password)
        auth_data = {
                      passwordCredentials: {
                        username: username,
                        password: password
                      }
                    }
      end

      request_body = auth_body(auth_data, options[:tenant] || options[:project])

      response = connection.post do |request|
        request.url resource_path(:token)
        request.body = request_body.to_json
      end

      self.token = instantiate_resource_or_raise(response, Resources::Token)
      self.token
    end
    
    
    def validate_token(options={})
      token_to_validate = extract_or_raise(options, :token)
      response = connection.get do |request| 
        request.url "#{ resource_path(:token) }/#{ token_to_validate[:id] }"
        request.headers['X-Auth-Token'] = self.token[:id]
      end
      
      case response.status
      when 200, 203
        true
      when 404
        false
      when 401, 403
        raise RedStack::NotAuthorizedError.new("Token #{ self.token[:id] } is not authorized to perform that action")
      else
        raise RedStack::UnexpectedError.new("Unexpected server response: #{ response.status }")
      end
    end
    

    private

    def auth_body(data, project)
      data = data.dup
      data.merge!({ tenantName: project }) if project

      { auth: data }
    end

    def instantiate_resource_or_raise(response, resource)
      case response.status
      when 200
        resource.new response.body
      end
    end

    def resource_path(name)
      "#{ api_version }/#{ name.to_s.pluralize }"
    end
    
  end

end
end
end