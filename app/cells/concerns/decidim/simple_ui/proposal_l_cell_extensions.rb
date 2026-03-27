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
          model.component.settings.main_image && controller.is_a?(Decidim::Proposals::ProposalsController)
        end

        def supports?
          model.component.current_settings.votes_enabled? && current_user
        end
      end
    end
  end
end
