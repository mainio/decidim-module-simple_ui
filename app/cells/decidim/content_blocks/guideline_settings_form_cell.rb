# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class GuidelineSettingsFormCell < Decidim::ViewModel
      alias form model

      def content_block
        options[:content_block]
      end

      def steps_options
        %w(idea develop vote follow)
      end
    end
  end
end
