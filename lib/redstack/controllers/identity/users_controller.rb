module RedStack
module Controllers
module Identity
    
  class UsersController
    
    include RedStack::Models::Identity
    
    attr_reader :session,
                :items
    
    def initialize(options={})
      @session = options[:session]
    end
    
    def find
      @items = User.find(session: session).map { |p| UserController.new(model: p) }
      self
    end
    
    def first
      items.first
    end
    
    def length
      items.length
    end
    
  end # class ProjectsController

end # module Identity
end # module Controllers
end # module RedStack