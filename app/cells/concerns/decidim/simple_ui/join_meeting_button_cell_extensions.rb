# frozen_string_literal: true

module Decidim
  module SimpleUi
    module JoinMeetingButtonCellExtensions
      extend ActiveSupport::Concern

      included do
        def button_classes
          "button button__xl button__secondary w-4/6 mb-4"
        end
      end
    end
  end
end
