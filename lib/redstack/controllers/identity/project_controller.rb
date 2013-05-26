module RedStack
module Controllers
module Identity
    
  class ProjectController
    
    include RedStack::Models::Identity
    
    attr_reader :project,
                :session
    
    def initialize(options={})
      @project = options[:model]
      @session = project.session
    end
    
    def users
      @users ||= UsersController.new(session: session)
    end
        
  end # class ProjectController

end # module Identity
end # module Controllers
end # module RedStack