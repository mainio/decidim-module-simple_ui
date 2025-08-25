# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class InstructionsSettingsFormCell < Decidim::ViewModel
      alias form model

      def content_block
        options[:content_block]
      end

      def steps_options
        %w(idea develop vote follow)
      end

      private

      def section_model_for(section_params)
        SimpleUi::Admin::IconSectionForm.from_params(section_params)
      end

      def blank_section
        @blank_section ||= SimpleUi::Admin::IconSectionForm.new
      end

      def available_icon_options

        @available_icon_options ||= SimpleUi::Admin::IconSectionForm.available_icons.map do |icon|
          [t(".icons.#{icon}"), icon]
        end
      end
    end
  end
end
