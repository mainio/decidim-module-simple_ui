# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ProposalsControllerExtensions
      extend ActiveSupport::Concern

      included do
        include Decidim::Proposals::ProposalVotesHelper
        include Decidim::Proposals::ApplicationHelper

        helper_method :rules

        def rules
          rules = []

          if vote_limit_enabled?
            rules << t("decidim.proposals.proposals.voting_rules.vote_limit.description", limit: component_settings.vote_limit)
          end

          if proposal_limit_enabled?
            rules << t("decidim.proposals.proposals.voting_rules.proposal_limit.description", limit: proposal_limit)
          end

          if threshold_per_proposal_enabled?
            rules << t("decidim.proposals.proposals.voting_rules.threshold_per_proposal.description", limit: threshold_per_proposal)
          end

          if can_accumulate_supports_beyond_threshold?
            rules << t("decidim.proposals.proposals.voting_rules.can_accumulate_supports_beyond_threshold.description", limit: threshold_per_proposal)
          end

          if minimum_votes_per_user_enabled?
            description = t("decidim.proposals.proposals.voting_rules.minimum_votes_per_user.description", votes: minimum_votes_per_user)

            votes =
              if votes_given >= minimum_votes_per_user
                t("decidim.proposals.proposals.voting_rules.minimum_votes_per_user.given_enough_votes")
              else
                t("decidim.proposals.proposals.voting_rules.minimum_votes_per_user.supports_remaining", remaining_votes: minimum_votes_per_user - votes_given)
              end

            rules << "#{description} #{votes}"
          end

          rules
        end
      end
    end
  end
end
