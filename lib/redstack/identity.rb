require 'redstack/identity/models/project'
require 'redstack/identity/models/user'
require 'redstack/identity/models/token'

module RedStack

  class Session
    
    def find_projects(options = {})
      Identity::Models::Project.find(
         endpoint_type: options[:endpoint_type] || 'public',
         token:         tokens[:default], 
         connection:    connection
       )
    end
    alias :find_tenants :find_projects
    
  end
  
end