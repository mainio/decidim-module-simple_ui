# frozen_string_literal: true

module Decidim
  module SimpleUi
    module Admin
      module UpdateSurveyExtensions
        extend ActiveSupport::Concern

        included do
          private

          def update_questionnaire_attributes
            @questionnaire.update!(
              title: @form.title,
              description: @form.description,
              tos: @form.tos,
              requires_tos_agreement: @form.requires_tos_agreement?
            )
          end
        end
      end
    end
  end
end
