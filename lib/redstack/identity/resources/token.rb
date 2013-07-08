module RedStack
module Identity
module Resources

  class Token

    attr_reader :attributes

    def initialize(json_str)
      @attributes = JSON.parse(json_str).deep_symbolize_keys
    end
    
    def [](attr_name)
      case attr_name
      when :id, :issued_at, :expires
        attributes[:access][:token][attr_name]
      when :service_catalog
        attributes[:access][:serviceCatalog]
      else
        attributes[:access][attr_name]
      end
    end
    
    def default?
      self[:service_catalog].empty?
    end
    
    def expired?
      Time.parse(self[:expires]).utc <= Time.now.utc
    end

  end

end
end
end