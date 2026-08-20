# frozen_string_literal: true

require "spec_helper"

describe "participatory processes" do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
  end

  describe "index page" do
    let!(:active_process) do
      create(
        :participatory_process,
        :active,
        :published,
        organization:,
        title: { en: "Active process" }
      )
    end

    let!(:past_process) do
      create(
        :participatory_process,
        :past,
        :published,
        organization:,
        title: { en: "Past process" }
      )
    end

    it "lists published participatory processes" do
      visit decidim_participatory_processes.participatory_processes_path

      expect(page).to have_content("Active process")
    end

    it "displays the page heading" do
      visit decidim_participatory_processes.participatory_processes_path

      expect(page).to have_content(I18n.t("decidim.participatory_processes.participatory_processes.index.all_processes"))
    end
  end

  describe "show page" do
    let(:participatory_process) do
      create(
        :participatory_process,
        :active,
        :published,
        :with_steps,
        organization:,
        title: { en: "My process" },
        short_description: { en: "Short description for my process" }
      )
    end

    let!(:hero_content_block) do
      create(
        :content_block,
        organization:,
        scope_name: :participatory_process_homepage,
        manifest_name: :hero,
        scoped_resource_id: participatory_process.id
      )
    end

    it "displays the process title" do
      visit decidim_participatory_processes.participatory_process_path(participatory_process)

      expect(page).to have_content("My process")
    end
  end
end
