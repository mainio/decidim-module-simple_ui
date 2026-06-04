# frozen_string_literal: true

module Decidim
  module SimpleUi
    module Accountability
      module ApplicationHelperExtensions
        extend ActiveSupport::Concern

        included do
          include Decidim::CheckBoxesTreeHelper

          # rubocop:disable Metrics/CyclomaticComplexity
          # rubocop:disable Metrics/PerceivedComplexity
          def filter_sections
            @filter_sections ||= begin
              items = []

              current_component.available_taxonomy_filters.each do |taxonomy_filter|
                items.append(method: "with_any_taxonomies[#{taxonomy_filter.root_taxonomy_id}]",
                            collection: filter_taxonomy_values_for(taxonomy_filter),
                            label: decidim_sanitize_translated(taxonomy_filter.name),
                            id: "taxonomy-#{taxonomy_filter.root_taxonomy_id}")
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
end
