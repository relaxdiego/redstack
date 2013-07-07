module RedStack
module Identity
module Clients

  module V2_0

    def api_version
      'v2.0'
    end

    def create_token(options={})
      if options[:token]
        token = options[:token]
      else
        username = extract_or_raise(options, :username)
        password = extract_or_raise(options, :password)
      end

      Token.new
    end

  end

end  
end
end