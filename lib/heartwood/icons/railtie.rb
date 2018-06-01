module Heartwood
  module Icons
    class Railtie < Rails::Railtie

      initializer 'heartwood-icons.view_helpers' do
        ActiveSupport.on_load(:action_view) do
          require_relative 'helper'
          include Heartwood::Icons::Helper
        end
      end

    end
  end
end
