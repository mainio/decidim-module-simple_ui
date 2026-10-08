# frozen_string_literal: true

module Decidim
  module SimpleUi
    module BudgetsListCellExtensions
      extend ActiveSupport::Concern

      included do
        def unvoted_budgets
          @unvoted_budgets ||= begin
            voted_ids = voted.map(&:id)
            highlighted_unvoted = reordered_highlighted_budgets.reject { |budget| voted_ids.include?(budget.id) }
            other = reorder(budgets).where.not(id: (highlighted + voted).map(&:id))

            highlighted_unvoted + other.to_a
          end
        end

        def votable_budgets
          @votable_budgets ||= unvoted_budgets.select do |budget|
            allowed_to?(:create, :order, budget:, workflow: current_workflow)
          end
        end

        def not_votable_budgets
          @not_votable_budgets ||= unvoted_budgets - votable_budgets
        end
      end
    end
  end
end
