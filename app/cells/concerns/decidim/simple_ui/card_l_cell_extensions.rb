# frozen_string_literal: true

module Decidim
  module SimpleUi
    module CardLCellExtensions
      extend ActiveSupport::Concern

      included do
        def explore_action_text
          if model.is_a?(Decidim::Debates::Debate) && model.open?
            t(".participate", default: t("simple_ui.actions.participate"))
          else
            t(".explore", default: t("simple_ui.actions.explore"))
          end
        end
      end
    end
  end
end
