# frozen_string_literal: true

require "spec_helper"

module Decidim
  module ParticipatoryProcesses
    module ContentBlocks
      describe PhasesCell, type: :cell do
        controller Decidim::PagesController

        subject { cell_instance }

        let(:organization) { create(:organization) }
        let(:participatory_process) { create(:participatory_process, organization:) }
        let(:content_block) do
          create(
            :content_block,
            organization:,
            scope_name: :participatory_process_homepage,
            manifest_name: :phases,
            scoped_resource_id: participatory_process.id
          )
        end
        let(:cell_instance) { cell("decidim/participatory_processes/content_blocks/phases", content_block) }

        before do
          allow(controller).to receive(:current_organization).and_return(organization)
        end

        describe "#step_classes_for" do
          let(:active_step_index) { 1 }

          before do
            allow(cell_instance).to receive(:active_step).and_return(active_step_index)
          end

          context "when the step is active" do
            let(:step) { OpenStruct.new(active: true) }

            it "includes the is-active class" do
              result = cell_instance.send(:step_classes_for, step, active_step_index)
              expect(result).to include("is-active")
              expect(result).to include("steps__step")
              expect(result).not_to include("is-future")
            end
          end

          context "when the step is in the future" do
            let(:step) { OpenStruct.new(active: false) }

            it "includes the is-future class" do
              result = cell_instance.send(:step_classes_for, step, active_step_index + 1)
              expect(result).to include("is-future")
              expect(result).to include("steps__step")
              expect(result).not_to include("is-active")
            end
          end

          context "when the step is in the past" do
            let(:step) { OpenStruct.new(active: false) }

            it "includes only the base class" do
              result = cell_instance.send(:step_classes_for, step, active_step_index - 1)
              expect(result).to include("steps__step")
              expect(result).not_to include("is-active")
              expect(result).not_to include("is-future")
            end
          end

          context "when there is only one step and it is active" do
            let(:active_step_index) { 0 }
            let(:step) { OpenStruct.new(active: true) }

            it "includes is-active without is-future" do
              result = cell_instance.send(:step_classes_for, step, 0)
              expect(result).to eq("steps__step is-active")
            end
          end
        end
      end
    end
  end
end
