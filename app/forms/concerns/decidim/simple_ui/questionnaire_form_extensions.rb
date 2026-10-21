# frozen_string_literal: true

module Decidim
  module SimpleUi
    module QuestionnaireFormExtensions
      extend ActiveSupport::Concern

      included do
        _validators[:tos_agreement].reject! { |validator| validator.is_a?(ActiveModel::Validations::AcceptanceValidator) } if _validators[:tos_agreement].present?

        _validate_callbacks.each do |callback|
          next unless callback.filter.respond_to?(:attributes)
          next unless callback.filter.attributes.include?(:tos_agreement)

          callback.filter.attributes.delete(:tos_agreement)
        end

        validates :tos_agreement, allow_nil: false, acceptance: true, if: :tos_agreement_required?

        def tos_agreement_required?
          response = responses.first

          return true if response.nil?

          questionnaire = response.question&.questionnaire

          return true if questionnaire.nil?

          questionnaire.requires_tos_agreement != false
        end
      end
    end
  end
end
