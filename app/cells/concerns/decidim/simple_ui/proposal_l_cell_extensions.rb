# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ProposalLCellExtensions
      extend ActiveSupport::Concern

      included do
        def more_info?
          true
        end
      end
    end
  end
end
