# frozen_string_literal: true

require "decidim/simple_ui/admin"
require "decidim/simple_ui/engine"
require "decidim/simple_ui/admin_engine"

module Decidim
  # This namespace holds the logic of the `SimpleUi` component. This component
  # allows users to create simple_ui in a participatory space.
  module SimpleUi
    autoload :SettingsManipulator, "decidim/simple_ui/settings_manipulator"
  end
end
