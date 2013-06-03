module RedStack
module Identity
module Controllers
    
  class TokensController
    
    include RedStack::Identity::Models
    
    attr_reader :session,
                :items
    
    def initialize(options={})
      @session = options[:session]
      @items   = []
    end
    
    def create(attributes={})
      item = TokenController.create(
              attributes: attributes, 
              session: session
             )
      items << item
      item
    end
    
    def each(&block)
      items.each &block
    end
    
    def find
      @items = Project.find(
                 connection: session.connection,
                 token: session.access['default']['token']['id']
               )
               .map { |p| ProjectController.new(model: p, session: session) }
      self
    end
    
    def first
      items.first
    end
    
    def length
      items.length
    end
    
  end # class TokensController

end # module Controllers
end # module Identity
end # module RedStack