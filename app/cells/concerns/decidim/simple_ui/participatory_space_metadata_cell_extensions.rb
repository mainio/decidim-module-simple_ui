# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ParticipatorySpaceMetadataCellExtensions
      extend ActiveSupport::Concern
      include Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper
    end
  end
end
