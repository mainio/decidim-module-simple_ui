# frozen_string_literal: true

require "decidim/core"

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs", prepend: true)
Decidim::Webpacker.register_entrypoints(
  decidim_simple_ui: "#{base_path}/app/packs/entrypoints/decidim_simple_ui.js",
  decidim_simple_ui_process_filters: "#{base_path}/app/packs/entrypoints/decidim_simple_ui_process_filters.js",
  decidim_simple_ui_content_blocks_admin: "#{base_path}/app/packs/entrypoints/decidim_simple_ui_content_blocks_admin.js",
  decidim_simple_ui_proposal_settings: "#{base_path}/app/packs/entrypoints/decidim_simple_ui_proposal_settings.js"
)
Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/simple_ui/simple_ui")

Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/budgets/budgets") unless Decidim.module_installed? :budgets_booth

