# frozen_string_literal: true

require "spec_helper"

describe "participatory process phases" do
  let(:organization) { create(:organization) }
  let(:participatory_process) do
    create(
      :participatory_process,
      :active,
      :published,
      organization:,
      title: { en: "Process with phases" }
    )
  end

  let!(:step1) do
    create(
      :participatory_process_step,
      participatory_process:,
      title: { en: "Ideation phase" },
      active: false,
      position: 0,
      start_date: 2.months.ago,
      end_date: 1.month.ago
    )
  end

  let!(:step2) do
    create(
      :participatory_process_step,
      participatory_process:,
      title: { en: "Voting phase" },
      active: true,
      position: 1,
      start_date: 1.month.ago,
      end_date: 1.month.from_now
    )
  end

  let!(:step3) do
    create(
      :participatory_process_step,
      participatory_process:,
      title: { en: "Results phase" },
      active: false,
      position: 2,
      start_date: 1.month.from_now,
      end_date: 2.months.from_now
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

  let!(:phases_content_block) do
    create(
      :content_block,
      organization:,
      scope_name: :participatory_process_homepage,
      manifest_name: :phases,
      scoped_resource_id: participatory_process.id
    )
  end

  before do
    switch_to_host(organization.host)
  end

  it "displays all phase titles" do
    visit decidim_participatory_processes.participatory_process_path(participatory_process)

    expect(page).to have_content("Ideation phase")
    expect(page).to have_content("Voting phase")
    expect(page).to have_content("Results phase")
  end

  it "marks the active step" do
    visit decidim_participatory_processes.participatory_process_path(participatory_process)

    within ".steps" do
      expect(page).to have_css(".steps__step.is-active", text: "Voting phase")
    end
  end

  it "marks future steps" do
    visit decidim_participatory_processes.participatory_process_path(participatory_process)

    within ".steps" do
      expect(page).to have_css(".steps__step.is-future", text: "Results phase")
    end
  end

  it "does not mark past steps as active or future" do
    visit decidim_participatory_processes.participatory_process_path(participatory_process)

    within ".steps" do
      ideation_step = find(".steps__step", text: "Ideation phase")
      expect(ideation_step[:class]).not_to include("is-active")
      expect(ideation_step[:class]).not_to include("is-future")
    end
  end
end
