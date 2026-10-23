# frozen_string_literal: true

module Decidim
  module SimpleUi
    module BudgetsControllerExtensions
      extend ActiveSupport::Concern

      included do
        before_action :ensure_multiple_budgets unless Decidim.module_installed?(:budgets_booth)

        private

        def ensure_multiple_budgets
          return true unless budgets.one?

          redirect_to decidim_budgets.budget_projects_path(budgets.first)
        end

        def decidim_budgets
          @decidim_budgets ||= Decidim::EngineRouter.main_proxy(current_component)
        end

        def budgets
          @budgets ||= Decidim::Budgets::Budget.where(component: current_component)
        end
      end
    end
  end
end
