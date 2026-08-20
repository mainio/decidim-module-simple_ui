# frozen_string_literal: true

require "spec_helper"

module Decidim
  module SimpleUi
    describe ApplicationHelper do
      let(:helper_class) do
        Class.new do
          include ActionView::Helpers::SanitizeHelper
          include Decidim::SimpleUi::ApplicationHelper
        end
      end

      let(:helper) { helper_class.new }

      describe "#style_rich_text" do
        context "when html is nil" do
          it "returns nil" do
            expect(helper.style_rich_text(nil)).to be_nil
          end
        end

        context "when html contains only whitespace" do
          it "returns nil" do
            expect(helper.style_rich_text("<p>  </p>")).to be_nil
          end
        end

        context "when html contains only empty tags" do
          it "returns nil" do
            expect(helper.style_rich_text("<p></p>")).to be_nil
          end
        end

        context "when html contains paragraphs" do
          it "adds styling classes to <p> elements" do
            result = helper.style_rich_text("<p>Hello world</p>")

            expect(result).to include('class="text-xl text-left md:text-center lg:w-4/6"')
            expect(result).to include("Hello world")
          end
        end

        context "when html contains links" do
          it "adds styling classes to <a> elements" do
            result = helper.style_rich_text("<p>Visit <a href='/test'>here</a></p>")

            expect(result).to include('class="text-[--primary] font-semibold underline"')
            expect(result).to include("here")
          end
        end

        context "when html contains multiple paragraphs and links" do
          it "styles all matching elements" do
            html = "<p>First</p><p>Second <a href='/a'>link A</a></p><p><a href='/b'>link B</a></p>"
            result = helper.style_rich_text(html)
            doc = Nokogiri::HTML::DocumentFragment.parse(result)

            expect(doc.css("p").length).to eq(3)
            expect(doc.css("a").length).to eq(2)
            doc.css("p").each { |p| expect(p["class"]).to eq("text-xl text-left md:text-center lg:w-4/6") }
            doc.css("a").each { |a| expect(a["class"]).to eq("text-[--primary] font-semibold underline") }
          end
        end

        context "when html contains elements other than p and a" do
          it "does not add classes to other elements" do
            result = helper.style_rich_text("<p>Hello</p><div>world</div><span>!</span>")
            doc = Nokogiri::HTML::DocumentFragment.parse(result)

            expect(doc.at_css("div")["class"]).to be_nil
            expect(doc.at_css("span")["class"]).to be_nil
          end
        end

        it "returns an html_safe string" do
          result = helper.style_rich_text("<p>Hello</p>")
          expect(result).to be_html_safe
        end
      end
    end
  end
end
