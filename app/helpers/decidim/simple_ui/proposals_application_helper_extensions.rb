# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ProposalsApplicationHelperExtensions
      extend ActiveSupport::Concern

      included do
        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/PerceivedComplexity
        def filter_sections
          @filter_sections ||= begin
            items = []
            if component_settings.proposal_answering_enabled && current_settings.proposal_answering_enabled
              items.append(method: :with_any_state, collection: filter_proposals_state_values, label_scope: "decidim.proposals.proposals.filters", id: "state")
            end
            if current_component.has_subscopes?
              items.append(method: :with_any_scope, collection: filter_scopes_values, label_scope: "decidim.proposals.proposals.filters", id: "scope")
            end
            if current_component.categories.any?
              items.append(method: :with_any_category, collection: filter_categories_values, label_scope: "decidim.proposals.proposals.filters", id: "category")
            end
            if current_user
              items.append(method: :activity, collection: activity_filter_values, label_scope: "decidim.proposals.proposals.filters", id: "activity", type: :radio_buttons)
            end
          end
          # rubocop:enable Metrics/PerceivedComplexity
          # rubocop:enable Metrics/CyclomaticComplexity

          items.reject { |item| item[:collection].blank? }
        end
      end
    end
  end
end
