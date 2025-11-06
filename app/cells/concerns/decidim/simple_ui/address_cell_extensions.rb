# frozen_string_literal: true

module Decidim
  module SimpleUi
    module AddressCellExtensions
      extend ActiveSupport::Concern

      included do
        def start_and_end_time
          <<~HTML
            #{l(model.start_time, format: "%H:%M")}
            -
            #{l(model.end_time, format: "%H:%M")}
          HTML
        end
      end
    end
  end
end
