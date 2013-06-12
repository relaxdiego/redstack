module RedStack
module Identity
module Models

  # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Role_Operations_OS-KSADM.html
  class Role < RedStack::Base::Model

    attribute :id
    attribute :name
    attribute :description


    def self.find(options={})
      super options.merge({ endpoint_type: 'admin' })
    end

    def self.resource_path
      "OS-KSADM/#{ super }"
    end

  end # class Role

end # module Models
end # module Identity
end # module RedStack

