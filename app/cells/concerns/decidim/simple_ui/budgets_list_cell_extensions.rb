# frozen_string_literal: true

module Decidim
  module SimpleUi
    module BudgetsListCellExtensions
      extend ActiveSupport::Concern

      included do
        def voted_budgets
          budgets.where.not(id: voted.map(&:id))
        end

        def votable_budgets?
          @votable_budgets ||= voted_budgets.any? do |budget|
            allowed_to?(:create, :order, budget:, workflow: current_workflow)
          end
        end
      end
    end
  end
end
