# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class ParticipatorySpaceLargeImageCell < Decidim::ContentBlocks::BaseCell
      include Decidim::SanitizeHelper

      def show
        return unless image_url

        render
      end

      def alt_text
        translated_attribute(model.settings.alt_text)
      end

      def image_url
        model.images_container.attached_uploader(:image)&.url if model.respond_to?(:images_container)
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
        hash << image_url

        hash.join(Decidim.cache_key_separator)
      end
    end
  end
end
