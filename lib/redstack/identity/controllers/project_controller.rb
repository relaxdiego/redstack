module RedStack
module Identity
module Controllers
    
  class ProjectController
    
    include RedStack::Identity::Models
    
    attr_reader :model,
                :session
    
    def self.create(options={})
      session = options[:session]
      session.request_admin_access
      service_endpoint = session.access['admin']['serviceCatalog']
                         .detect{ |s|s['type']=='identity' }['endpoints'][0]['adminURL']
      connection = session.connection.dup
      connection.url_prefix = service_endpoint    
      attributes = options[:attributes]

      project = Project.create(
                  attributes: attributes, 
                  token: session.access['admin']['token']['id'],
                  connection: connection
                )
      new(model: project, session: session)
    end
    
    def initialize(options={})
      @model   = options[:model]
      @session = options[:session]
    end
    
    def [](key)
      model[key]
    end
    
    def users
      @users ||= UsersController.new(session: session)
    end
        
  end # class ProjectController

end # module Controllers
end # module Identity
end # module RedStack