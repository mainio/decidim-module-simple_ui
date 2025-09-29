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

            prepend_view_path(simple_views) if Decidim.module_installed?(:privacy)
        end
      end

      initializer "decidim_simple_ui.add_customizations", after: "decidim.action_controller" do
        config.to_prepare do
          # Cell extensions
          Decidim::ContentBlocks::ParticipatorySpaceHeroCell.include(
            Decidim::SimpleUi::ParticipatorySpaceHeroCellExtensions
          )
          Decidim::ContentBlocks::ParticipatorySpaceMetadataCell.include(
            Decidim::SimpleUi::ParticipatorySpaceMetadataCellExtensions
          )
          Decidim::ShareButtonCell.include(
            Decidim::SimpleUi::ShareButtonCellExtensions
          )
          Decidim::Meetings::JoinMeetingButtonCell.include(
            Decidim::SimpleUi::JoinMeetingButtonCellExtensions
          )

          # Controller extensions
          Decidim::HomepageController.include(
            Decidim::SimpleUi::HomepageControllerExtensions
          )

          # Helper extensions
          Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper.include(
            Decidim::SimpleUi::ParticipatoryProcessHelperExtensions
          )
          Decidim::Proposals::ApplicationHelper.include(
            Decidim::SimpleUi::ProposalsApplicationHelperExtensions
          )
        end
      end

      initializer "decidim_simple_ui.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_simple_ui.register_icons" do |_app|
        Decidim.icons.register(name: "login-box-line", icon: "user-line", category: "system", description: "Sign in", engine: :core)
        Decidim.icons.register(name: "checkbox-multiple-line", icon: "checkbox-multiple-line", category: "system", description: "Checkbox", engine: :core)
        Decidim.icons.register(name: "settings-2-line", icon: "settings-2-line", category: "system", description: "Settings-2", engine: :core)
      end

      initializer "decidim_simple_ui.content_blocks" do
        # Home page
        Decidim.content_blocks.register(:homepage, :intro) do |content_block|
          content_block.cell = "decidim/content_blocks/intro"
          content_block.public_name_key = "decidim.content_blocks.intro.name"
          content_block.settings_form_cell = "decidim/content_blocks/intro_settings_form"

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
            settings.attribute :button_url, type: :text, translated: true
            settings.attribute :image_alt, type: :text, translated: true
          end
        end

        Decidim.content_blocks.register(:homepage, :instructions) do |content_block|
          content_block.cell = "decidim/content_blocks/instructions"
          content_block.public_name_key = "decidim.content_blocks.instructions.name"
          content_block.settings_form_cell = "decidim/content_blocks/instructions_settings_form"

          content_block.settings do |settings|
            settings.attribute :title, type: :text, translated: true
            settings.attribute :button_text, type: :text, translated: true
            settings.attribute :button_url, type: :text, translated: true
            settings.attribute :sections, type: :array
          end
        end

        Decidim.content_blocks.register(:homepage, :infolift) do |content_block|
          content_block.cell = "decidim/content_blocks/infolift"
          content_block.public_name_key = "decidim.content_blocks.infolift.name"
          content_block.settings_form_cell = "decidim/content_blocks/infolift_settings_form"

          content_block.settings do |settings|
            settings.attribute :title, type: :text, translated: true
            settings.attribute :description, type: :text, translated: true
            settings.attribute :button_text, type: :text, translated: true
            settings.attribute :button_url, type: :text, translated: true
          end
        end

        # Participatory spaces
        participatory_space_defaults = [:hero, :main_data, :phases]

        # Processes
        if Decidim.module_installed?(:participatory_processes)
          Decidim.content_blocks.register(:participatory_process_homepage, :phases) do |content_block|
            content_block.cell = "decidim/participatory_processes/content_blocks/phases"
            content_block.public_name_key = "decidim.participatory_processes.content_blocks.phases.name"
          end

          Decidim.content_blocks.for(:participatory_process_homepage).each do |content_block|
            content_block.default = participatory_space_defaults.include?(content_block.name)
          end
        end
      end
    end
  end
end
