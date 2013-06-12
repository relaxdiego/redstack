module RedStack

  class NotAuthorizedError < StandardError; end
  class ResourceNotFoundError < StandardError; end  
  class UnexpectedError < StandardError; end

end