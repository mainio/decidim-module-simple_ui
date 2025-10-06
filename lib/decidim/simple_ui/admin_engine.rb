# frozen_string_literal: true

module Decidim
  module SimpleUi
    # This is the engine that runs on the public interface of `SimpleUi`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::SimpleUi::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      initializer "decidim_simple_ui_admin.component_settings" do
        # Add the extra settings for all components needed to add extra data
        # needed to be managed dynamically through the admin panel.
        [:blogs, :debates, :meetings, :proposals, :sortitions].each do |manifest_name|
          component = Decidim.find_component_manifest(manifest_name)
          next unless component

          component.settings(:global) do |settings|
            settings.attribute :intro, type: :text, translated: true, editor: true

            m = Decidim::SimpleUi::SettingsManipulator.new(settings)
            m.move_attribute_before(:intro, :announcement)
          end
        end
      end

      initializer "decidim_simple_ui_admin.add_customizations", after: "decidim.action_controller" do
        config.to_prepare do
          if Decidim.module_installed?(:forms)
            Decidim::Forms::Admin::UpdateQuestionnaire.include(
              Decidim::SimpleUi::Admin::UpdateQuestionnaireExtensions
            )
            Decidim::Forms::Admin::QuestionnaireForm.include(
              Decidim::SimpleUi::Admin::QuestionnaireFormExtensions
            )
          end
        end
      end

      def load_seed
        nil
      end
    end
  end
end
