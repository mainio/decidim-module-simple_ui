# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/simple_ui/version"

Gem::Specification.new do |s|
  s.version = Decidim::SimpleUi::VERSION
  s.authors = ["Joonas"]
  s.email = ["joonas.aapro@mainiotech.fi"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-simple_ui"
  s.required_ruby_version = "~> 3.1"

  s.name = "decidim-simple_ui"
  s.summary = "A decidim simple_ui module"
  s.description = "This component's purpose is to clean up Decidim version 0.28's UI and make it simpler."

  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w(app/ config/ db/ lib/ LICENSE-AGPLv3.txt Rakefile README.md))
    end
  end

  s.add_dependency "decidim-core", Decidim::SimpleUi::DECIDIM_VERSION
  s.add_dependency "text-hyphen", "~> 1.5"
end
