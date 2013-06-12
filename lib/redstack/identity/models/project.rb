module RedStack
module Identity
module Models
  
  # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Tenant_Operations.html 
  class Project < RedStack::Base::Model

    resource  'tenant'

    attribute :id      
    attribute :name
    attribute :description
    attribute :enabled,     default: true
            
    def users(options = {})
      @users ||= User.find(
                   url_prefix:    "#{ resource_path }/#{ self[:id] }",
                   token:         token,
                   connection:    connection,
                   querystring:   options[:querystring]
                 )
    end

  end # class Project

end # module Models
end # module Identity
end # module RedStack
  
