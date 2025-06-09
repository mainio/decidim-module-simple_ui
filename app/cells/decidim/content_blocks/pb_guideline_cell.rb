# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class PbGuidelineCell < Decidim::ViewModel
      include Decidim::SanitizeHelper

      def translated_title
        translated_attribute(model.settings.title)
      end

      def render?(step)
        model.settings.steps.include?(step)
      end

      private

      # A MD5 hash of model attributes because is needed because
      # the model does not respond to cache_key_with_version nor updated_at method
      def cache_hash
        hash = []
        hash << "decidim/content_blocks/pb_guideline"
        hash << Digest::MD5.hexdigest(model.attributes.to_s)
        hash << current_organization.cache_key_with_version
        hash << I18n.locale.to_s

        hash.join(Decidim.cache_key_separator)
      end
    end
  end
end
