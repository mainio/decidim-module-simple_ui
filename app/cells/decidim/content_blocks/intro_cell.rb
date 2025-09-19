# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class IntroCell < Decidim::ViewModel
      include Decidim::CtaButtonHelper
      include Decidim::SanitizeHelper

      def show
        return if title.blank? && description.blank?

        super
      end

      # Needed so that the `CtaButtonHelper` can work.
      def decidim_participatory_processes
        Decidim::ParticipatoryProcesses::Engine.routes.url_helpers
      end

      def title
        model.settings.title
      end

      def description
        model.settings.description
      end

      def button_text
        model.settings.button_text
      end

      def button_url
        translated_attribute(model.settings.button_url)
      end

      def hero_image
        model.images_container.attached_uploader(:hero_image)&.url
      end

      def image_alt
        translated_attribute(model.settings.image_alt).presence || (hero_image.present? ? File.basename(URI.parse(hero_image).path) : "image_alt")
      end

      private

      # A MD5 hash of model attributes because is needed because
      # the model does not respond to cache_key_with_version nor updated_at method
      def cache_hash
        hash = []
        hash << "decidim/content_blocks/intro"
        hash << Digest::MD5.hexdigest(model.attributes.to_s)
        hash << current_organization.cache_key_with_version
        hash << I18n.locale.to_s
        hash << hero_image

        hash.join(Decidim.cache_key_separator)
      end
    end
  end
end
