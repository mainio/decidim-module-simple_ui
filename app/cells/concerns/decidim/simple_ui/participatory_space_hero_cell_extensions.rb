# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ParticipatorySpaceHeroCellExtensions
      extend ActiveSupport::Concern
      include Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper
      include Decidim::ComponentPathHelper
      include ActiveLinkTo

      included do
        def nav_items
            process_nav_items(resource)
        end

        def show_menu?
          return unless model

          model.settings.show_menu
        end
      end
    end
  end
end
