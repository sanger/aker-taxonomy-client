module TaxonomyClient
  class ResponseHandlerFactory

    attr_reader :model

    def initialize(options)
      @model = options.fetch(:model)
    end

    def build(response)
      if (response.body.kind_of? Array)
        response.body.map{|o| model.new(HashWithIndifferentAccess.new(o)) }
      else
        body = HashWithIndifferentAccess.new(response.body)
        model.new(body)
      end
    end

  end
end