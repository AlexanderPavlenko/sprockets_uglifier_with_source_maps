module SprocketsUglifierWithSM
  class Compressor < Sprockets::UglifierCompressor

    def evaluate(context, locals, &block)
      options = {comments: false}.merge!(Rails.application.config.assets.uglifier.to_h)
      compressed_data, sourcemap = Uglifier.new(options).compile_with_map(data)

      uncompressed_filename = File.join(Rails.application.config.assets.prefix, Rails.application.config.assets.uncompressed_prefix, "#{context.logical_path}-#{digest(data)}.js")

      sourcemap = JSON.parse(sourcemap)
      sourcemap['file'] = "#{context.logical_path}.js"
      sourcemap['sources'] = [uncompressed_filename]
      sourcemap = sourcemap.to_json

      sourcemap_filename = File.join(Rails.application.config.assets.prefix, Rails.application.config.assets.sourcemaps_prefix, "#{context.logical_path}-#{digest(sourcemap)}.js.map")

      sourcemap_path = File.join(Rails.public_path, sourcemap_filename)
      uncompressed_path = File.join(Rails.public_path, uncompressed_filename)
      FileUtils.mkdir_p [File.dirname(sourcemap_path), File.dirname(uncompressed_path)]
      File.open(sourcemap_path, 'w') { |f| f.write sourcemap }
      File.open(uncompressed_path, 'w') { |f| f.write data }

      compressed_data.concat "\n//# sourceMappingURL=#{sourcemap_filename}\n"
    end

    private

    def digest(io)
      Rails.application.assets.digest.update(io).hexdigest
    end
  end
end
