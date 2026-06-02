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

              if current_component.has_subscopes?
                items.append(method: :with_scope, collection: filter_scopes_values, label_scope: "decidim.proposals.proposals.filters", id: "scope")
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
