# frozen_string_literal: true

module Decidim
  module SimpleUi
    module HomepageControllerExtensions
      extend ActiveSupport::Concern

      included do
        def show
          @frontpage = true
        end
      end
    end
  end
end
