# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ParticipatoryProcessHelperExtensions
      extend ActiveSupport::Concern

      included do

        def filter_sections
          [
            { method: :with_date, collection: filter_dates_values, label_scope: "decidim.participatory_processes.participatory_processes.filters", id: "process-date" }
          ].reject { |item| item[:collection].blank? }
        end
      end
    end
  end
end
