# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class CurrentTopicCell < Decidim::ViewModel
      include Decidim::CtaButtonHelper
      include Decidim::SanitizeHelper

      # Needed so that the `CtaButtonHelper` can work.
      def decidim_participatory_processes
        Decidim::ParticipatoryProcesses::Engine.routes.url_helpers
      end

      def translated_title
        translated_attribute(model.settings.title)
      end

      def translated_description
        translated_attribute(model.settings.description)
      end

      def translated_button_text
        translated_attribute(model.settings.button_text)
      end

      def button_url
        translated_attribute(model.settings.button_url)
      end

      private

      # A MD5 hash of model attributes because is needed because
      # the model does not respond to cache_key_with_version nor updated_at method
      def cache_hash
        hash = []
        hash << "decidim/content_blocks/current_topic"
        hash << Digest::MD5.hexdigest(model.attributes.to_s)
        hash << current_organization.cache_key_with_version
        hash << I18n.locale.to_s

        hash.join(Decidim.cache_key_separator)
      end
    end
  end
end
