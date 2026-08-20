# frozen_string_literal: true

require "spec_helper"

module Decidim
  module SimpleUi
    module Admin
      describe IconSectionForm do
        subject(:form) { described_class.from_params(attributes).with_context(context) }

        let(:organization) { create(:organization) }
        let(:context) { { current_organization: organization } }
        let(:title) { Decidim::Faker::Localized.sentence(word_count: 3) }
        let(:description) { Decidim::Faker::Localized.paragraph }
        let(:icon) { "lightbulb-flash-line" }
        let(:position) { 0 }
        let(:deleted) { false }

        let(:attributes) do
          {
            title:,
            description:,
            icon:,
            position:,
            deleted:
          }
        end

        context "when all attributes are valid" do
          it { is_expected.to be_valid }
        end

        context "when title is blank" do
          let(:title) { {} }

          it { is_expected.not_to be_valid }
        end

        context "when description is blank" do
          let(:description) { {} }

          it { is_expected.not_to be_valid }
        end

        context "when icon is not in the allowed list" do
          let(:icon) { "not-an-allowed-icon" }

          it { is_expected.not_to be_valid }
        end

        context "when each available icon is used" do
          described_class.available_icons.each do |valid_icon|
            context "with icon #{valid_icon}" do
              let(:icon) { valid_icon }

              it { is_expected.to be_valid }
            end
          end
        end

        context "when deleted is true" do
          let(:deleted) { true }
          let(:title) { {} }
          let(:description) { {} }

          it "skips validations on title and description" do
            expect(form).to be_valid
          end
        end

        describe "#to_param" do
          context "when id is present" do
            before { form.id = 42 }

            it "returns the id" do
              expect(form.to_param).to eq(42)
            end
          end

          context "when id is blank" do
            it 'returns "icon-section-id"' do
              expect(form.to_param).to eq("icon-section-id")
            end
          end
        end

        describe ".available_icons" do
          it "returns an array of icon name strings" do
            expect(described_class.available_icons).to be_an(Array)
            expect(described_class.available_icons).to all(be_a(String))
          end

          it "includes the expected icons" do
            expected = %w(
              lightbulb-flash-line settings-2-line checkbox-multiple-line
              eye-line login-box-line discuss-line map-pin-line
              pencil-line calendar-line like share
            )
            expect(described_class.available_icons).to match_array(expected)
          end

          it "is memoized" do
            expect(described_class.available_icons).to equal(described_class.available_icons)
          end
        end
      end
    end
  end
end
