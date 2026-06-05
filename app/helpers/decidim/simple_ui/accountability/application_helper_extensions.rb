# frozen_string_literal: true

module Decidim
  module SimpleUi
    module Accountability
      module ApplicationHelperExtensions
        extend ActiveSupport::Concern

        included do
          include Decidim::CheckBoxesTreeHelper

          def filter_sections
            @filter_sections ||= current_component.available_taxonomy_filters.filter_map do |taxonomy_filter|
              collection = filter_taxonomy_values_for(taxonomy_filter)
              next if collection.blank?

              {
                method: "with_any_taxonomies[#{taxonomy_filter.root_taxonomy_id}]",
                collection:,
                label: decidim_sanitize_translated(taxonomy_filter.name),
                id: "taxonomy-#{taxonomy_filter.root_taxonomy_id}"
              }
            end
          end
        end
      end
    end
  end
end
