module RedStack

  class Session
    attr_accessor :access,
                  :api_version,
                  :host
    
    attr_reader   :identity_service,
                  :stub_openstack

    def initialize(options = {})
      @api_version    = options[:api_version]
      @host           = options[:host]
      @access         = { 'default' => nil }
    end
    
    def authenticate(options = {})
      if options.has_key? :username
        authenticate_with_credentials(options)
      else
        authenticate_with_token(options)
      end
    end
    
    def authenticate_with_credentials(options = {})
      response = nil
      path     = connection.url_prefix.path + '/tokens'
      
      VCR.use_cassette(path, record: :new_episodes, match_requests_on: [:body, :method]) do
        response = connection.post do |req|
          req.url 'tokens'
          req.body = {
            auth: {
              passwordCredentials: {
                username: options[:username],
                password: options[:password],
                tenant:   options[:tenant] || options[:project] || ''
              }
            }
          }.to_json
        end
      end
            
      case response.status
      when 200
        value       = JSON.parse(response.body)['access']
        key         = value['token']['tenant'].nil? ? 'default' : value['token']['tenant']['id']
        access[key] = value
      when 401
        access['default'] = nil
      end
    end
    
    def authenticate_with_token(options = {})
      response = nil
      path     = connection.url_prefix.path + '/tokens'
      
      VCR.use_cassette(path, record: :new_episodes, match_requests_on: [:headers, :body, :method]) do
        response = connection.post do |req|
          req.url 'tokens'
          req.body = {
            auth: {
              tenantName: options[:tenant] || options[:project] || '',
              token: {
                id: options[:token]
              }
            }
          }.to_json
        end
      end
            
      case response.status
      when 200
        value       = JSON.parse(response.body)['access']
        key         = value['token']['tenant'].nil? ? 'default' : value['token']['tenant']['id']
        access[key] = value
      when 401
        access['default'] = nil
      end
    end
    
    def authenticated?
      !access['default'].nil?
    end
    
    def is_admin?
      !access['admin'].nil?
    end
    
    def projects
      @projects ||= Identity::Controllers::ProjectsController.new(session: self)
    end
    
    def request_admin_access
      unless is_admin?
        user_projects = projects.find
        user_projects.each do |project|
          authenticate token: access['default']['token']['id'], project: project['name']
          if access[project['id']]['user']['roles'].detect { |h| h['name']=='admin' }
            access['admin'] = access[project['id']]
          end
        end
      end

      is_admin?
    end
    
    def uri(path=nil)
      URI.join(host, api_version)
    end
    
    def connection
      @connection ||= Faraday::Connection.new(:url => uri.to_s) do |c|
        c.headers['Content-Type'] = 'application/json'
        c.adapter Faraday.default_adapter
      end
    end
    
  end # class Session

end # module RedStack
