lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sprockets_uglifier_with_source_maps/version'

Gem::Specification.new do |spec|
  spec.name          = 'sprockets_uglifier_with_source_maps'
  spec.version       = SprocketsUglifierWithSM::VERSION
  spec.authors       = ['Alexander Pavlenko']
  spec.email         = ['alerticus@gmail.com']
  spec.summary       = %q{Create javascript source maps for your Rails 4.2 applications}
  spec.description   = %q{sprockets_uglifier_with_source_maps creates source maps for your javascript assets along with their compression using uglifier.}
  spec.homepage      = 'https://github.com/AlexanderPavlenko/sprockets_uglifier_with_source_maps'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'sprockets-rails', '>= 3.0.0.beta1'
  spec.add_runtime_dependency 'uglifier', '>= 2.5'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
