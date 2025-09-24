# frozen_string_literal: true

require "text/hyphen"

module Decidim
  module ContentBlocks
    class InstructionsCell < Decidim::ViewModel
      include Decidim::SanitizeHelper

      def title
        model.settings.title
      end

      def button_text
        model.settings.button_text
      end

      def button_url
        translated_attribute(model.settings.button_url)
      end

      private

      def sections
        @sections ||= model.settings.sections.map do |section_data|
          SimpleUi::Admin::IconSectionForm.from_params(section_data)
        end
      end

      def description_for(section)
        return if section.description.blank?

        description = translated_attribute(section.description)
        return if description.blank?

        description = strip_tags(description)
        hh = Text::Hyphen.new(language: I18n.locale, left: 2, right: 2)
        hh.visualise(description, "&shy;")
      end

      # A MD5 hash of model attributes because is needed because
      # the model does not respond to cache_key_with_version nor updated_at method
      def cache_hash
        hash = []
        hash << "decidim/content_blocks/instructions"
        hash << Digest::MD5.hexdigest(model.attributes.to_s)
        hash << current_organization.cache_key_with_version
        hash << I18n.locale.to_s

        hash.join(Decidim.cache_key_separator)
      end
    end
  end
end
