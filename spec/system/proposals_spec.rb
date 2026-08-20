# frozen_string_literal: true

require "spec_helper"

describe "Proposals" do
  include_context "with a component"

  let(:manifest_name) { "proposals" }
  let(:organization) { create(:organization) }
  let!(:component) do
    create(
      :component,
      :published,
      manifest_name: :proposals,
      participatory_space: participatory_process,
      settings: { main_image: false }
    )
  end

  let(:participatory_process) do
    create(:participatory_process, :active, :published, :with_steps, organization:)
  end

  before do
    switch_to_host(organization.host)
  end

  describe "index page" do
    let!(:proposals) do
      create_list(:proposal, 3, :published, component:)
    end

    it "lists the proposals" do
      visit_component

      proposals.each do |proposal|
        expect(page).to have_content(translated(proposal.title))
      end
    end

    it "shows the proposal count" do
      visit_component

      expect(page).to have_content("3 ideas")
    end

    context "with proposal answering enabled" do
      before do
        component.update!(
          settings: {
            proposal_answering_enabled: true
          },
          step_settings: {
            participatory_process.active_step.id => {
              proposal_answering_enabled: true
            }
          }
        )
      end

      let!(:accepted_proposal) do
        create(:proposal, :accepted, :published, component:)
      end

      it "shows the state filter" do
        visit_component

        expect(page).to have_css("[id*='state'], [name*='state']")
      end
    end
  end

  describe "show page" do
    let!(:proposal) do
      create(
        :proposal,
        :published,
        component:,
        title: { en: "My great proposal" },
        body: { en: "This is the proposal body with details." }
      )
    end

    it "displays the proposal title and body" do
      visit_component

      click_on translated(proposal.title)

      expect(page).to have_content("My great proposal")
      expect(page).to have_content("This is the proposal body with details.")
    end

    it "shows a back link" do
      visit_component

      click_on translated(proposal.title)

      expect(page).to have_content(
        I18n.t("decidim.proposals.proposals.show.back_to_listing")
      )
    end
  end
end
