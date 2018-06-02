module Heartwood
  module Icons
    module Helper

      def heartwood_icon(name, options = {})
        classes  = "hw-icon hw-icon-#{name}"
        classes += " hw-icon-#{options[:size]}" if options[:size].present?
        classes += " hw-icon-#{options[:color]}" if options[:color].present?
        classes += " #{options[:class]}" if options[:class].present?

        href = "#{image_path('icons.svg')}##{name}"

        render partial: 'heartwood/icon', locals: { classes: classes, name: name, href: href }
      end

    end
  end
end
