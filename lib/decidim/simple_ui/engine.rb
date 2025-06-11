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
          # Cell extensions
          Decidim::ContentBlocks::ParticipatorySpaceHeroCell.include(
            Decidim::SimpleUi::ParticipatorySpaceHeroCellExtensions
          )

          # Helper extensions
          Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper.include(Decidim::SimpleUi::ParticipatoryProcessHelperExtensions)
        end
      end

      initializer "SimpleUi.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_simple_ui.register_icons" do |_app|
        Decidim.icons.register(name: "login-box-line", icon: "user-line", category: "system", description: "Sign in", engine: :core)
        Decidim.icons.register(name: "checkbox-multiple-line", icon: "checkbox-multiple-line", category: "system", description: "Checkbox", engine: :core)
        Decidim.icons.register(name: "settings-2-line", icon: "settings-2-line", category: "system", description: "Settings-2", engine: :core)
      end

      Decidim.content_blocks.register(:homepage, :custom_hero) do |content_block|
        content_block.cell = "decidim/content_blocks/custom_hero"
        content_block.public_name_key = "decidim.content_blocks.custom_hero.name"
        content_block.settings_form_cell = "decidim/content_blocks/custom_hero_settings_form"

        content_block.images = [
          {
            name: :hero_image,
            uploader: "Decidim::HomepageImageUploader"
          }
        ]

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
          settings.attribute :description, type: :text, translated: true
          settings.attribute :button_text, type: :text, translated: true
        end
      end

      Decidim.content_blocks.register(:homepage, :pb_guideline) do |content_block|
        content_block.cell = "decidim/content_blocks/pb_guideline"
        content_block.public_name_key = "decidim.content_blocks.pb_guideline.name"
        content_block.settings_form_cell = "decidim/content_blocks/pb_guideline_settings_form"

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
          settings.attribute :steps, type: :array
        end
      end

      Decidim.content_blocks.register(:homepage, :current_topic) do |content_block|
        content_block.cell = "decidim/content_blocks/current_topic"
        content_block.public_name_key = "decidim.content_blocks.current_topic.name"
        content_block.settings_form_cell = "decidim/content_blocks/current_topic_settings_form"

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
          settings.attribute :description, type: :text, translated: true
          settings.attribute :button_text, type: :text, translated: true
        end
      end
    end
  end
end
