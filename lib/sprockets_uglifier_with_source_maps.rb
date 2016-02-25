require 'sprockets_uglifier_with_source_maps/version'
require 'sprockets'
require 'sprockets_uglifier_with_source_maps/compressor'
Sprockets.register_compressor 'application/javascript', :uglifier_with_source_maps, SprocketsUglifierWithSM::Compressor
Sprockets.register_compressor 'application/javascript', :uglify_with_source_maps, SprocketsUglifierWithSM::Compressor
require 'sprockets/railtie'
require 'sprockets_uglifier_with_source_maps/railtie'
