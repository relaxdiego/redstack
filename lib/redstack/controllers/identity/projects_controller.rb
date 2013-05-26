require 'redstack/models/identity/project.rb'

module RedStack
module Controllers
module Identity
    
  class ProjectsController
    
    include RedStack::Models::Identity
    
    attr_reader :session,
                :items
    
    def initialize(session)
      @session = session
    end
    
    def find
      Project.find session: session
    end
    
  end # class ProjectController

end # module Identity
end # module Controllers
end # module RedStack