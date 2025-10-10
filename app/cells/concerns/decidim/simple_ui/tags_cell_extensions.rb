# frozen_string_literal: true

module Decidim
  module SimpleUi
    module TagsCellExtensions
      extend ActiveSupport::Concern

      included do
        def card_tag
          render :card_tag if category? || scope?
        end

        def tag(name, title)
          sr_title = content_tag(
            :span,
            title,
            class: "sr-only"
          )
          display_title = content_tag(
            :span,
            name,
            "aria-hidden": true
          )

          content_tag :div, class: "flex items-center space-x-1 fill-gray-2 text-gray-2" do
            icon("price-tag-3-line") + sr_title + display_title
          end
        end
      end
    end
  end
end
