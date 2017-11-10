require 'json'

module TaxonomyClient
  class Model
    class_attribute :site,
                    :connection_class,
                    :connection_object,
                    :connection_options,
                    :endpoint,
                    :response_handler,
                    :requestor

    self.site = ENV['TAXONOMY_URL']

    self.connection_class     = TaxonomyClient::Connection
    self.connection_options   = { :headers => { 
      "Content-Type" => "application/json", "Accept" => "application/json" } }

    attr_reader :attributes

    def initialize(attributes = {})
      set_attributes(self.class.default_attributes.merge(attributes))
    end

    def attributes
      @attributes ||= ActiveSupport::HashWithIndifferentAccess.new
    end

    def ==(other)
      return self.id == other.id && self.class.to_s == other.class.to_s
    end

    class << self

      def find(id)
        requestor.get(id)
      end

      def from_json(json)
        attributes = JSON.parse(json)
        new(attributes)
      end

      def connection(rebuild = false, &block)
        _build_connection(rebuild, &block)
        @connection_object
      end

      def response_handler(rebuild = false)
        _build_response_handler(rebuild)
        @response_handler
      end

      def requestor(rebuild = false)
        _build_requester(rebuild)
        @requestor
      end


      def default_attributes
        Hash.new
      end

      protected

      def _build_connection(rebuild = false)
        return @connection_object unless @connection_object.nil? || rebuild
        @connection_object = connection_class.new(connection_options.merge(site: site)).tap do |conn|
          yield(conn) if block_given?
        end
      end

      def _build_response_handler(rebuild = false)
        return @response_handler unless @response_handler.nil? || rebuild
        @response_handler = TaxonomyClient::ResponseHandlerFactory.new(model: self)
      end

      def _build_requester(rebuild = false)
        return @requestor unless @requestor.nil? || rebuild
        @requestor = TaxonomyClient::Requestor.new(klass: self)
      end

      
    end


    private

    def set_attributes(attrs)
      return @attributes unless attrs.present?
      attrs.each do |key, value|
        send("#{key}=", value)
      end
    end

    def method_missing(method, *args, &block)
      normalized_method = method.to_s

      # If it contains an equals after some letter(s)...
      if normalized_method =~ /^(.*)=$/
        set_attribute($1, args.first)

      elsif has_attribute?(normalized_method)
        attributes[method]
      else
        super
      end

    end

    def set_attribute(name, value)
      attributes[name] = value
    end

    def has_attribute?(attribute)
      attributes.has_key?(attribute)
    end

  end
end