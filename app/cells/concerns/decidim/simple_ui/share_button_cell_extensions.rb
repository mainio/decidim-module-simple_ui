# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ShareButtonCellExtensions
      extend ActiveSupport::Concern

      included do
        def button_classes
          if options[:default_classes] == false
            "button button__lg button__transparent-secondary"
          else
            "button button__sm button__text-secondary"
          end
        end
      end
    end
  end
end
