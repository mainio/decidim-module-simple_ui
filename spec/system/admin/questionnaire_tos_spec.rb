# frozen_string_literal: true

require "spec_helper"

describe "admin questionnaire TOS toggle" do
  include_context "when managing a component as an admin"

  let(:manifest_name) { "surveys" }

  let!(:survey) { create(:survey, component:) }
  let(:questionnaire) { survey.questionnaire }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  it "shows the requires TOS agreement checkbox in the questionnaire form" do
    visit manage_component_path(component)

    within "table", match: :first do
      find("a", match: :first).click
    end

    expect(page).to have_css("[id*='requires_tos']", visible: :all)
  end

  it "toggles visibility of the TOS editor based on checkbox" do
    visit manage_component_path(component)

    within "table", match: :first do
      find("a", match: :first).click
    end

    tos_content = find_by_id("tos-agreement-content", visible: :all)
    expect(tos_content).not_to be_visible

    find("[id*='requires_tos']", visible: :all).click

    expect(tos_content).to be_visible
  end
end
