module TaxonomyClient
  class Requestor

    attr_reader :klass

    def initialize(options)
      @klass = options.fetch(:klass)
    end

    def get(path=nil, params = {}, headers = {})
      request(:get, path, {}, headers)
    end

  private

    def request(action, path, params, headers)
      klass.response_handler.build(klass.connection.run(action, path, params, headers))
    end

  end
end