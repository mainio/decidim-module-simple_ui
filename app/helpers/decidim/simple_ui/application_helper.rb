# frozen_string_literal: true

module Decidim
  module SimpleUi
    # Custom helpers, scoped to the simple_ui engine.
    #
    module ApplicationHelper
      def style_rich_text(html)
        return if strip_tags(html).blank?

        doc = Nokogiri::HTML::DocumentFragment.parse(html)
        doc.css("p").each { |p| p["class"] = "text-xl text-left md:text-center lg:w-4/6" }
        doc.css("a").each { |a| a["class"] = "text-[--primary] font-semibold underline" }

        doc.to_html.html_safe
      end
    end
  end
end
