# frozen_string_literal: true

require "spec_helper"

module Decidim
  module SimpleUi
    describe "version" do
      it "has a version number" do
        expect(Decidim::SimpleUi::VERSION).to be_present
      end

      it "follows semver format" do
        expect(Decidim::SimpleUi::VERSION).to match(/\A\d+\.\d+\.\d+/)
      end

      it "has a DECIDIM_VERSION constraint" do
        expect(Decidim::SimpleUi::DECIDIM_VERSION).to be_present
      end

      it "DECIDIM_VERSION is a pessimistic constraint matching VERSION major.minor" do
        major_minor = Decidim::SimpleUi::VERSION.split(".")[0..1].join(".")
        expect(Decidim::SimpleUi::DECIDIM_VERSION).to include(major_minor)
      end
    end
  end
end
