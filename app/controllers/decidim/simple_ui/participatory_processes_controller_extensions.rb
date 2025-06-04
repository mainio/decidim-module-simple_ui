# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ParticipatoryProcessesControllerExtensions
      extend ActiveSupport::Concern

      included do

        helper_method :collection,
        :promoted_collection,
        :participatory_processes,
        :stats,
        :metrics,
        :participatory_process_group,
        :default_date_filter,
        :related_processes,
        :linked_assemblies,
        :organization_participatory_processes
      end
    end
  end
end
