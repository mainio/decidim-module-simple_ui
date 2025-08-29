# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module ContentBlocks
      class PhasesCell < Decidim::ContentBlocks::ParticipatorySpaceMetadataCell
      def show
        render
      end

        private

        def steps
          @steps ||= resource.steps
        end

        def active_step
          @active_step ||= steps.find_index(&:active)
        end

        def step_classes_for(step, idx)
          %w(steps__step).tap do |cls|
            cls << "is-active" if step.active
            cls << "is-future" if idx > active_step
          end.join(" ")
        end
      end
    end
  end
end
