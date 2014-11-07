require 'action_controller/railtie'

module SprocketsUglifierWithSM
  class Railtie < ::Rails::Railtie

    initializer 'sprockets-uglifier-with-source-maps.environment', after: 'sprockets.environment', group: :all do |app|
      config = app.config
      config.assets.sourcemaps_prefix ||= 'maps'
      config.assets.uncompressed_prefix ||= 'sources'
    end
  end
end
