module RedStack
module Identity
module Clients

  module V2_0

    def api_version
      'v2.0'
    end

    def authenticate(options={})
      if options[:token]
        token = options[:token]
        request_body = {
                         auth: {
                           token: {
                             id: token[:id]
                           },
                           tenantName: options[:tenant] || options[:project]
                         }
                       }
      else
        username     = extract_or_raise(options, :username)
        password     = extract_or_raise(options, :password)
        request_body = {
                         auth: {
                           passwordCredentials: {
                             username: username,
                             password: password
                           },
                           tenantName: options[:tenant] || options[:project]
                         }
                       }
      end

      response = connection.post do |request|
        request.url resource_path(:token)
        request.body = request_body.to_json
      end

      instantiate_resource_or_raise(response, Resources::Token)
    end


    private

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