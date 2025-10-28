# frozen_string_literal: true

module Decidim
  module SimpleUi
    module Proposals
      module MapHelperExtensions
        extend ActiveSupport::Concern

        included do
          def proposal_data_for_map(proposal)
            proposal
              .slice(:latitude, :longitude, :address)
              .merge(
                title: decidim_html_escape(present(proposal).title),
                body: decidim_html_escape(present(proposal).body),
                link: proposal_path(proposal),
                items: cell("decidim/proposals/proposal_metadata", proposal).send(:proposal_items_for_map).to_json
              )
          end
        end
      end
    end
  end
end
