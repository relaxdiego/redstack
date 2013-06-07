module RedStack
module Identity
module Models
  
  # http://docs.openstack.org/api/openstack-identity-service/2.0/content/User_Operations.html
  class User < RedStack::Base::Model      
  
    attribute :id
    attribute :username,  key: 'name'
    attribute :email
    attribute :enabled,   default: true
    attribute :password,  key: 'OS-KSADM:password', read: false
        
  end # class User

end # module Models
end # module Identity
end # module RedStack
