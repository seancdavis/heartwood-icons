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

      def wrap_icons
        tmpl = File.read(File.expand_path('./templates/icon_wrapper.svg.erb', __dir__))
        @icons_sprite = ERB.new(tmpl).result(binding)
      end

      def fix_indentation
        @icons_sprite = Nokogiri::XML(@icons_sprite).to_xml
      end

      def write_sprite
        dest = Rails.root.join('app', 'assets', 'images', 'icons.svg')
        template 'icons_sprite.svg.erb', dest, force: true
      end

      private

        def strip_attrs(doc)
          %w{id stroke stroke-width fill fill-rule transform}.each do |attr|
            doc.css("[#{attr}]").each { |n| n.delete(attr) }
          end
          doc
        end

    end
  end
end



###########

# require 'rexml/document'

# desc 'Combine all SVG icons into a single SVG'
# task :build_svg do
#   icons_dir = Rails.root.join('app', 'assets', 'images', 'icons')

#   # rubocop:disable Metrics/LineLength
#   svg_content = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
# <svg width=\"256px\" height=\"256px\" viewBox=\"0 0 256 256\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"
#   # rubocop:enable Metrics/LineLength

#   Dir.glob("#{icons_dir}/*.svg").each do |file|
#     doc = Nokogiri::XML(File.read(file))
#     icon_name = doc.css('#Page-1 > g')[0]['id']
#     content = doc.css('#Page-1 g').to_s
#     # rubocop:disable Metrics/LineLength
#     svg_content += "<svg width=\"256px\" height=\"256px\" viewBox=\"0 0 256 256\" id=\"#{icon_name}\">\
#   #{content.gsub(/[a-z\-]+=\"[a-zA-Z0-9\-\#]+\"/, '')}\
# </svg>"
#     # rubocop:enable Metrics/LineLength
#   end
#   svg_content += '</svg>'

#   svg_content = REXML::Document.new(svg_content)
#   output = ''
#   svg_content.write(output, 2)

#   icons_file = Rails.root.join('app', 'assets', 'images', 'icons.svg')
#   File.open(icons_file, 'w+') { |file| file.write(output) }
# end
