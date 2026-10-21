# frozen_string_literal: true

require "spec_helper"

describe "SurveyTOS" do
  include_context "with a component"

  let(:manifest_name) { "surveys" }

  let!(:survey) do
    create(:survey, component:, allow_responses: true, published_at: Time.current)
  end
  let(:questionnaire) { survey.questionnaire }
  let!(:question) do
    create(
      :questionnaire_question,
      questionnaire:,
      body: { en: "What is your name?" },
      position: 0
    )
  end
  let(:user) { create(:user, :confirmed, organization:) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  context "when requires_tos_agreement is false" do
    before do
      questionnaire.update!(
        title: { en: "Simple survey" },
        description: { en: "A survey without TOS" },
        tos: nil,
        requires_tos_agreement: false
      )
    end

    it "doesn't require TOS agreement to answer" do
      visit_component

      click_on "Simple survey"

      expect(page).to have_no_css("#questionnaire_tos_agreement")
      click_on "Submit"
      click_on "OK"
      expect(page).to have_content("Survey successfully responded.")
    end
  end

  context "when requires_tos_agreement is true" do
    before do
      questionnaire.update!(
        title: { en: "Survey with TOS" },
        description: { en: "A survey requiring TOS" },
        tos: { en: "You must accept these terms" },
        requires_tos_agreement: true
      )
    end

    it "requires TOS agreement to answer" do
      visit_component

      click_on "Survey with TOS"

      expect(page).to have_css("#questionnaire_tos_agreement")

      click_on "Submit"
      click_on "OK"
      expect(page).to have_content("There was a problem responding the survey.")
      check "questionnaire_tos_agreement"
      click_on "Submit"
      click_on "OK"
      expect(page).to have_content("Survey successfully responded.")
    end
  end
end
