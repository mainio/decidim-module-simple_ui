# frozen_string_literal: true

class AddTosRequiresTosAgreementToDecidimFormsQuestionnaires < ActiveRecord::Migration[6.1]
  class FormsQuestionnaire < ApplicationRecord
    self.table_name = :decidim_forms_questionnaires
  end

  def change
    add_column :decidim_forms_questionnaires, :requires_tos_agreement, :boolean, default: false

    # Make the option `true` for all existing questionnaires assuming they have
    # required user's consent.
    FormsQuestionnaire.update_all(requires_tos_agreement: true)
  end
end
