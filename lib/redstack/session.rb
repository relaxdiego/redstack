module RedStack

  class Session
    attr_accessor :api_version,
                  :host
    
    attr_reader   :identity_service,
                  :stub_openstack

    def initialize(options = {})
      @api_version = options[:api_version]
      @host        = options[:host]
      @tokens      = {}
    end
    
    def authenticate(options = {})
      token = Identity::Models::Token.create(
                connection: connection,
                attributes: {
                  username: options[:username], 
                  password: options[:password] 
                }
              )
      
      if token.is_default?
        @tokens[:default] = token
      end
    end
    
    def authenticated?
      !tokens[:default].nil?
    end
    
    def is_admin?
      !tokens[:admin].nil?
    end
    
    def projects
      @projects ||= Identity::Controllers::ProjectsController.new(session: self)
    end
    
    def request_admin_access
      unless is_admin?
        user_projects = projects.find
        user_projects.each do |project|
          authenticate token: access['default']['token']['id'], project: project['name']
          next if access[project['id']].nil?
          if access[project['id']]['user']['roles'].detect { |h| h['name']=='admin' }
            access['admin'] = access[project['id']]
          end
        end
      end

      is_admin?
    end
    
    def tokens
      @tokens
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
