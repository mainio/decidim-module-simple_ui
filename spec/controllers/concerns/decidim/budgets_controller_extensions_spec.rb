# frozen_string_literal: true

require "spec_helper"

module Decidim
  module SimpleUi
    describe BudgetsControllerExtensions do
      controller(::Decidim::Budgets::BudgetsController) do
        include BudgetsControllerExtensions
      end

      routes { Decidim::Budgets::Engine.routes }

      let(:user) { create(:user, :confirmed, organization:) }
      let(:organization) { create(:organization) }
      let(:component) { create(:budgets_component, organization:) }
      let!(:first_budget) { create(:budget, component:) }
      let(:decidim_budgets) { Decidim::EngineRouter.main_proxy(component) }
      let(:params) { { initiative_slug: component.participatory_space.slug, component_id: component.id } }

      describe "#index" do
        before do
          request.env["decidim.current_organization"] = organization
          request.env["decidim.current_component"] = component
          request.env["decidim.current_participatory_space"] = component.participatory_space
        end

        context "when budgets_booth is added" do
          before do
            allow(Decidim).to receive(:module_installed?).with(:budgets_booth).and_return(true)
          end

          it "does not register a duplicate before action" do
            callbacks = controller.class._process_action_callbacks.select do |callback|
              callback.kind == :before &&
                callback.filter == :ensure_multiple_budgets
            end

            expect(callbacks.size).to eq(1)
          end
        end

        context "when only one budget exists" do
          it "redirects to the budget projects list" do
            get(:index, params:)

            expect(response).to redirect_to(
              decidim_budgets.budget_projects_path(first_budget)
            )
          end
        end

        context "when more than one budget exists" do
          let!(:another_budget) { create(:budget, component:) }

          it "renders the budgets list view" do
            get(:index, params:)

            expect(response).to have_http_status(:ok)
            expect(response).to render_template(:index)
          end
        end
      end
    end
  end
end
