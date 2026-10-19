# frozen_string_literal: true

module Decidim
  module SimpleUi
    module FooterTopicsCellExtensions
      extend ActiveSupport::Concern

      included do
        def topics
          @topics ||= footer_topics.map do |topic|
            next if topic.pages.empty?

            {
              title: decidim_escape_translated(topic.title),
              path: decidim.page_path(topic.pages.first),
              pages: topic.pages.map do |page|
                {
                  title: decidim_escape_translated(page.title),
                  path: decidim.page_path(page)
                }
              end
            }
          end
        end

        private

        def footer_topics
          @footer_topics = current_organization
                           .static_page_topics
                           .where(show_in_footer: true)
                           .includes(:pages)
        end
      end
    end
  end
end
