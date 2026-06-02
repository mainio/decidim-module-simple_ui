# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ResultExtensions
      extend ActiveSupport::Concern

      included do
        def self.ransackable_scopes(_auth_object = nil)
          [:with_category, :with_scope, :with_any_scope]
        end
      end
    end
  end
end
