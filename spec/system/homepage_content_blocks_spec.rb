# frozen_string_literal: true

require "spec_helper"

describe "Homepage content blocks" do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
  end

  describe "Intro content block" do
    let!(:content_block) do
      create(
        :content_block,
        organization:,
        scope_name: :homepage,
        manifest_name: :intro,
        settings: {
          title: { en: "Welcome to our platform" },
          description: { en: "This is the intro description" },
          button_text: { en: "Get started" },
          button_url: { en: "/processes" }
        }
      )
    end

    it "displays the intro block with title and description" do
      visit decidim.root_path

      within ".custom-hero" do
        expect(page).to have_content("Welcome to our platform")
        expect(page).to have_content("This is the intro description")
      end
    end

    it "displays the CTA button when configured" do
      visit decidim.root_path

      within ".custom-hero" do
        expect(page).to have_link("Get started", href: "/processes")
      end
    end

    context "when title is blank" do
      let!(:content_block) do
        create(
          :content_block,
          organization:,
          scope_name: :homepage,
          manifest_name: :intro,
          settings: {
            title: {},
            description: { en: "Only description" },
            button_text: {},
            button_url: {}
          }
        )
      end

      it "renders the block without a heading" do
        visit decidim.root_path

        within ".custom-hero" do
          expect(page).to have_content("Only description")
          expect(page).to have_no_css("h1")
        end
      end
    end
  end

  describe "Infolift content block" do
    let!(:content_block) do
      create(
        :content_block,
        organization:,
        scope_name: :homepage,
        manifest_name: :infolift,
        settings: {
          title: { en: "Important announcement" },
          description: { en: "Here is some important information" },
          button_text: { en: "Learn more" },
          button_url: { en: "/pages/info" }
        }
      )
    end

    it "displays the infolift block with title and description" do
      visit decidim.root_path

      within ".infolift" do
        expect(page).to have_content("Important announcement")
        expect(page).to have_content("Here is some important information")
      end
    end

    it "displays the CTA button" do
      visit decidim.root_path

      within ".infolift" do
        expect(page).to have_link("Learn more", href: "/pages/info")
      end
    end

    context "when only title is provided" do
      let!(:content_block) do
        create(
          :content_block,
          organization:,
          scope_name: :homepage,
          manifest_name: :infolift,
          settings: {
            title: { en: "Title only" },
            description: {},
            button_text: {},
            button_url: {}
          }
        )
      end

      it "renders just the title without description or button" do
        visit decidim.root_path

        within ".infolift" do
          expect(page).to have_content("Title only")
          expect(page).to have_no_css("a")
        end
      end
    end
  end

  describe "Instructions content block" do
    let!(:content_block) do
      create(
        :content_block,
        organization:,
        scope_name: :homepage,
        manifest_name: :instructions,
        settings: {
          title: { en: "How to participate" },
          button_text: { en: "Start now" },
          button_url: { en: "/processes" },
          sections: [
            {
              title: { en: "Share ideas" },
              description: { en: "Submit your proposals" },
              icon: "lightbulb-flash-line",
              position: 0,
              deleted: false
            },
            {
              title: { en: "Vote" },
              description: { en: "Support the best ideas" },
              icon: "like",
              position: 1,
              deleted: false
            }
          ]
        }
      )
    end

    it "displays the instructions block with title" do
      visit decidim.root_path

      within ".instructions" do
        expect(page).to have_content("Share ideas")
        expect(page).to have_content("Vote")
      end
    end

    it "displays the section descriptions" do
      visit decidim.root_path

      within ".instructions" do
        # Descriptions contain soft hyphens (&shy;) inserted by text-hyphen
        expect(page.text.gsub("\u00AD", "")).to include("Submit your proposals")
        expect(page.text.gsub("\u00AD", "")).to include("Support the best ideas")
      end
    end

    it "displays the CTA button" do
      visit decidim.root_path

      expect(page).to have_link("Start now", href: "/processes")
    end
  end
end
