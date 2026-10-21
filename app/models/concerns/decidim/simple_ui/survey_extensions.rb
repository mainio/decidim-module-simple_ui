# frozen_string_literal: true

module Decidim
  module SimpleUi
    module SurveyExtensions
      extend ActiveSupport::Concern

      included do
        delegate :requires_tos_agreement, to: :questionnaire
      end
    end
  end
end
