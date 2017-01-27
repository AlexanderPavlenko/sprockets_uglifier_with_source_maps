require 'sprockets/digest_utils'
require 'sprockets/uglifier_compressor'

module SprocketsUglifierWithSM
  class Compressor < Sprockets::UglifierCompressor

    DEFAULTS = { comments: false }

    def initialize(options = {})
      # merge in any options passed in from our rails configuration - i wish
      # rails actually did this by default :/
      @options = options.merge(DEFAULTS).merge!(Rails.application.config.assets.uglifier.to_h)
      super @options
    end

    def call(input)
      data = input.fetch(:data)
      name = input.fetch(:name)

      uglifier = Sprockets::Autoload::Uglifier.new(@options)
      compressed_data, sourcemap = uglifier.compile_with_map(data)

      uncompressed_filename = File.join(Rails.application.config.assets.prefix, Rails.application.config.assets.uncompressed_prefix, "#{name}-#{digest(data)}.js")
      uncompressed_url      = filename_to_url uncompressed_filename

      sourcemap            = JSON.parse(sourcemap)
      sourcemap['file']    = "#{name}.js"
      sourcemap['sources'] = [uncompressed_url]

      sourcemap = sourcemap.to_json

      sourcemap_filename = File.join(Rails.application.config.assets.prefix, Rails.application.config.assets.sourcemaps_prefix, "#{name}-#{digest(sourcemap)}.js.map")

      sourcemap_path    = File.join(Rails.public_path, sourcemap_filename)
      uncompressed_path = File.join(Rails.public_path, uncompressed_filename)
      FileUtils.mkdir_p [File.dirname(sourcemap_path), File.dirname(uncompressed_path)]
      File.open(sourcemap_path, 'w') { |f| f.write sourcemap }
      File.open(uncompressed_path, 'w') { |f| f.write data }

      if Rails.application.config.assets.sourcemaps_gzip
        [sourcemap_path, uncompressed_path].each do |f|
          Zlib::GzipWriter.open("#{f}.gz") do |gz|
            gz.mtime     = File.mtime(f)
            gz.orig_name = f
            gz.write IO.binread(f)
          end
        end
      end

      sourcemap_url = filename_to_url sourcemap_filename
      compressed_data.concat "\n//# sourceMappingURL=#{sourcemap_url}\n"
    end

    private

    def filename_to_url(filename)
      url_root = Rails.application.config.assets.sourcemaps_url_root
      case url_root
      when FalseClass
        filename
      when Proc
        url_root.call filename
      else
        File.join url_root.to_s, filename
      end
    end

    def digest(io)
      Sprockets::DigestUtils.pack_hexdigest Sprockets::DigestUtils.digest(io)
    end
  end
end
