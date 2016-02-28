require 'action_controller/railtie'

module SprocketsUglifierWithSM
  class Railtie < ::Rails::Railtie

    initializer 'sprockets-uglifier-with-source-maps.environment', group: :all do |app|
      config = app.config
      config.assets.sourcemaps_prefix ||= 'maps'
      config.assets.uncompressed_prefix ||= 'sources'
      config.assets.sourcemaps_gzip ||= false
      config.assets.sourcemaps_url_root ||= false
    end
  end
end
