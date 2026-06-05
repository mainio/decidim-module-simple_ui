# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ProposalsApplicationHelperExtensions
      extend ActiveSupport::Concern

      included do
        def filter_sections
          @filter_sections ||= begin
            items = []
            if component_settings.proposal_answering_enabled && current_settings.proposal_answering_enabled
              items.append(method: :with_any_state, collection: filter_proposals_state_values, label: t("decidim.proposals.proposals.filters.state"), id: "state")
            end
            current_component.available_taxonomy_filters.each do |taxonomy_filter|
              items.append(method: "with_any_taxonomies[#{taxonomy_filter.root_taxonomy_id}]",
                           collection: filter_taxonomy_values_for(taxonomy_filter),
                           label: decidim_sanitize_translated(taxonomy_filter.name),
                           id: "taxonomy-#{taxonomy_filter.root_taxonomy_id}")
            end

            items.append(method: :activity, collection: activity_filter_values, label: t("decidim.proposals.proposals.filters.state"), id: "activity", type: :radio_buttons) if current_user
          end
          items.reject { |item| item[:collection].blank? }
        end
      end
    end
  end
end
