# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs")
Decidim::Webpacker.register_entrypoints(
  decidim_simple_ui: "#{base_path}/app/packs/entrypoints/decidim_simple_ui.js",
  decidim_simple_ui_login: "#{base_path}/app/packs/entrypoints/decidim_simple_ui_login.js",
  decidim_simple_ui_process_filters: "#{base_path}/app/packs/entrypoints/decidim_simple_ui_process_filters.js"
)
Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/simple_ui/simple_ui")
