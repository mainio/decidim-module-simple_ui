# frozen_string_literal: true

require "decidim/core"

base_path = File.expand_path("..", __dir__)

Decidim::Shakapacker.register_path("#{base_path}/app/packs", prepend: true)
Decidim::Shakapacker.register_entrypoints(
  decidim_simple_ui: "#{base_path}/app/packs/entrypoints/decidim_simple_ui.js",
  decidim_simple_ui_process_filters: "#{base_path}/app/packs/entrypoints/decidim_simple_ui_process_filters.js",
  decidim_simple_ui_content_blocks_admin: "#{base_path}/app/packs/entrypoints/decidim_simple_ui_content_blocks_admin.js",
  decidim_simple_ui_proposal_settings: "#{base_path}/app/packs/entrypoints/decidim_simple_ui_proposal_settings.js",
  decidim_simple_ui_registration: "#{base_path}/app/packs/entrypoints/decidim_simple_ui_registration.js"
)
unless Decidim.module_installed?(:budgets_booth)
  Decidim::Shakapacker.register_entrypoints(
    decidim_simple_ui_progress_fixed: "#{base_path}/app/packs/entrypoints/decidim_simple_ui_progress_fixed.js"
  )
end
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/accountability")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/blogs")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/budgets")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/collaborative_texts") if Decidim.module_installed?(:collaborative_texts)
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/conversations")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/meetings")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/processes")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/proposals")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/surveys")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/simple_ui")
