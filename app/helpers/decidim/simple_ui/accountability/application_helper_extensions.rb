# frozen_string_literal: true

module Decidim
  module SimpleUi
    module Accountability
      module ApplicationHelperExtensions
        extend ActiveSupport::Concern

        included do
          include Decidim::CheckBoxesTreeHelper

          def filter_sections
            @filter_sections ||= begin
              items = []

              if current_component.has_subscopes?
                items.append(method: :with_any_scope, collection: filter_scopes_values, label_scope: "decidim.proposals.proposals.filters", id: "scope")
              end
            end
            items.reject { |item| item[:collection].blank? }
          end
        end
      end
    end
  end
end
