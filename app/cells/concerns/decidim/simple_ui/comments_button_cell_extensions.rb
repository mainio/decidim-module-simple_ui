# frozen_string_literal: true

module Decidim
  module SimpleUi
    module CommentsButtonCellExtensions
      extend ActiveSupport::Concern

      included do
        def button_classes
          "button button__lg button__transparent-secondary add-comment-mobile"
        end
      end
    end
  end
end
