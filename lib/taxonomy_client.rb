require "taxonomy_client/version"
require 'active_model'
require 'active_support/all'
require 'faraday'

module TaxonomyClient
  autoload :Connection,              'taxonomy_client/connection'    
  autoload :Requestor,               'taxonomy_client/requestor'
  autoload :Errors,                  'taxonomy_client/errors'
  autoload :Middleware,              'taxonomy_client/middleware'
  autoload :ResponseHandlerFactory,  'taxonomy_client/response_handler_factory'
  autoload :Model,                   'taxonomy_client/models/model'
  autoload :Taxonomy,                'taxonomy_client/models/taxonomy'
end
