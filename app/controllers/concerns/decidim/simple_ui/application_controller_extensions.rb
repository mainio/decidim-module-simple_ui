# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ApplicationControllerExtensions
      extend ActiveSupport::Concern

      included do
        before_action :register_controller
      end

      private

      def register_controller
        snippets.add(:foot, view_context.javascript_pack_tag("decidim_simple_ui_registration"))
      end
    end
  end
end
