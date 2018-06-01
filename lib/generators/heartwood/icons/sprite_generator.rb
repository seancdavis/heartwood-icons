require 'nokogiri'
require 'rails/generators'

module Heartwood
  module Icons
    class SpriteGenerator < Rails::Generators::Base

      desc "Create an SVG icon sprite file."

      source_root File.expand_path("./templates", __dir__)

      attr_reader :svg_content, :icons_sprite

      def init
        @svg_content = ''
      end

      # Step through every SVG file in the app/assets/images/icons directory in
      # the rails app.
      #
      # We only look at top-level "g" elements, and strip their interfering
      # attributes.
      def process_icons
        icons_dir = Rails.root.join('app', 'assets', 'images', 'icons')
        tmpl = File.read(File.expand_path("./templates/icon.svg.erb", __dir__))
        Dir.glob("#{icons_dir}/*.svg").each do |file|
          icon_name = File.basename(file, '.svg')
          doc = Nokogiri::XML(File.read(file))
          icon_content = strip_attrs(doc).css('svg > g').to_s
          @svg_content += ERB.new(tmpl).result(binding)
        end
      end

      # Wrap our SVG icon markup in one SVG/XML document.
      def wrap_icons
        tmpl = File.read(File.expand_path('./templates/icon_wrapper.svg.erb', __dir__))
        @icons_sprite = ERB.new(tmpl).result(binding)
      end

      # Fix indentation in sprite markup.
      def fix_indentation
        @icons_sprite = Nokogiri::XML(@icons_sprite, &:noblanks).to_xml
      end

      # Write the sprite to file in the Rails app (app/assets/images/icons.svg).
      def write_sprite
        dest = Rails.root.join('app', 'assets', 'images', 'icons.svg')
        template 'icons_sprite.svg.erb', dest, force: true
      end

      private

        # Strips attributes that tend to interfere with making the sprite render
        # properly and helps to give the developer more control over the styles.
        def strip_attrs(doc)
          %w{id stroke stroke-width fill fill-rule}.each do |attr|
            doc.css("[#{attr}]").each { |n| n.delete(attr) }
          end
          doc
        end

    end
  end
end
