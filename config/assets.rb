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
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/simple_ui")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/accountability/results")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/proposals/proposals")
Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/meetings/meetings")

Decidim::Shakapacker.register_stylesheet_import("stylesheets/decidim/simple_ui/budgets/budgets") unless Decidim.module_installed? :budgets_booth
