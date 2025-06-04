# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module SimpleUi
    # This is the engine that runs on the public interface of simple_ui.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SimpleUi

      routes do
        # Add engine routes here
        # resources :simple_ui
        # root to: "simple_ui#index"
      end

      initializer "decidim_simple_ui.add_cells_view_paths", before: "decidim_core.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::SimpleUi::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::SimpleUi::Engine.root}/app/views")
      end

      initializer "decidim_simple_ui.view_priority" do
        ActiveSupport.on_load(:action_controller) do
          simple_views = Decidim::SimpleUi::Engine.root.join("app", "views")

          if Decidim.module_installed? :privacy
            prepend_view_path(simple_views)
          end
        end
      end

      initializer "decidim_simple_ui.add_customizations", after: "decidim.action_controller" do
        config.to_prepare do
          # Controller extensions
          Decidim::ParticipatoryProcesses::ParticipatoryProcessesController.include(
            Decidim::SimpleUi::ParticipatoryProcessesControllerExtensions
          )
        end
      end

      initializer "SimpleUi.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_simple_ui.register_icons" do |_app|
        Decidim.icons.register(name: "login-box-line", icon: "user-line", category: "system", description: "Sign in", engine: :core)
      end
    end
  end
end
