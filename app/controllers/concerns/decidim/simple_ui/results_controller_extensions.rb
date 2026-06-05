# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ResultsControllerExtensions
      extend ActiveSupport::Concern

      included do
        private

        def results
          @results ||= begin
            parent_id = params[:parent_id].presence
            search.result.where(
              parent_id: [parent_id] + Decidim::Accountability::Result.where(parent_id:).pluck(:id)
            ).page(params[:page]).per(params[:per_page] || 25)
          end
        end

        def default_filter_params
          {
            search_text_cont: "",
            with_any_taxonomies: nil
          }
        end
      end
    end
  end
end
