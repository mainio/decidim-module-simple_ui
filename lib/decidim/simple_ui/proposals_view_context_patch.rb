# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ProposalsViewContextPatch
      def self.render(controller, component, **)
        renderer = Decidim::Proposals::ProposalsController.renderer.new(
          controller.request.env.dup.merge(
            "decidim.current_component" => component,
            "decidim.current_participatory_space" => component.participatory_space
          )
        )

        renderer.render(**)
      end
    end
  end
end
