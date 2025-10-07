# frozen_string_literal: true

module Decidim
  module SimpleUi
    module Admin
      module QuestionnaireFormExtensions
        extend ActiveSupport::Concern

        included do
          _validators[:tos].reject! { |validator| validator.is_a?(TranslatablePresenceValidator) } if _validators[:tos].present?

          _validate_callbacks.each do |callback|
            next unless callback.raw_filter.respond_to?(:attributes)
            next unless callback.raw_filter.attributes.include?(:tos)

            callback.raw_filter.attributes.delete(:tos)
          end

          attribute :requires_tos_agreement, :boolean, default: false

          validates :tos, translatable_presence: true, if: :requires_tos_agreement?
        end
      end
    end
  end
end
