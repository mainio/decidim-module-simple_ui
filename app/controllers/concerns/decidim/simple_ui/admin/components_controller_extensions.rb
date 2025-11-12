# frozen_string_literal: true

module Decidim
  module SimpleUi
    module Admin
      module ComponentsControllerExtensions
        extend ActiveSupport::Concern

        included do
          def edit
            @component = query_scope.find(params[:id])
            enforce_permission_to :update, :component, component: @component

            proposal_component_javascript

            @form = form(@component.form_class).from_model(@component)
          end

          private

          def proposal_component_javascript
            snippets.add(:foot, view_context.javascript_pack_tag("decidim_simple_ui_proposal_settings"))
          end
        end
      end
    end
  end
end
