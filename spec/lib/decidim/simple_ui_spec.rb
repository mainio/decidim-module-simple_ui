# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe SimpleUi do
    it "has a module namespace" do
      expect(described_class).to be_a(Module)
    end

    it "autoloads SettingsManipulator" do
      expect(Decidim::SimpleUi::SettingsManipulator).to be_a(Class)
    end
  end

  describe SimpleUi::Admin do
    it "has an Admin submodule" do
      expect(described_class).to be_a(Module)
    end
  end
end
