require 'rails/generators'

module Heartwood
  module Icons
    class SpriteGenerator < Rails::Generators::Base

      desc "Create an SVG icon sprite file."

      # argument :name, required: true

      # source_root File.expand_path("../templates", __FILE__)

      def init
        puts 'PENDING: Generate SVG icon sprite file ...'
      end

    end
  end
end
