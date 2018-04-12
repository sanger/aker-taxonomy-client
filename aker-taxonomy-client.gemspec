# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "taxonomy_client/version"

Gem::Specification.new do |spec|
  spec.name          = "aker_taxonomy_client"
  spec.version       = TaxonomyClient::VERSION
  spec.authors       = ["Eduardo Martin Rojo"]
  spec.email         = ["emr@sanger.ac.uk"]

  spec.summary       = %q{Ruby REST client to access EBI/ENA Taxonomy Service.}
  spec.description   = %q{Faraday based REST client to obtain Taxonomy information from EBI.}
  spec.homepage      = "https://github.com/sanger/aker-taxonomy-client"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://mygemserver.sanger.ac.uk"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency 'activemodel'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'

end
