# frozen_string_literal: true

module Decidim
  module SimpleUi
    module CardGCellExtensions
      extend ActiveSupport::Concern

      included do
        def title_class
          "#{highlight? ? "h3" : "h4"} text-primary"
        end
      end
    end
  end
end
