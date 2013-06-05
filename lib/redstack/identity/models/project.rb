module RedStack
module Identity
module Models
  
  # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Tenant_Operations.html 
  class Project < RedStack::Base::Model

    resource  'tenant'

    attribute :id      
    attribute :name
    attribute :description
    attribute :enabled
            
  end # class Project

end # module Models
end # module Identity
end # module RedStack
  
