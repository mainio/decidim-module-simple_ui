# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ProposalLCellExtensions
      extend ActiveSupport::Concern

      included do
        def more_info?
          true
        end

        def main_image?
          component_settings.main_image
        end

        def supports?
          current_settings.votes_enabled? && current_user
        end
      end
    end
  end
end
