module ServiceHelper
  class Success
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def successful? = true
    def failed? = !successful?
  end

  class Failure
    attr_reader :error

    def initialize(error)
      @error = error
    end

    def successful? = false
    def failed? = !successful?
  end
end
