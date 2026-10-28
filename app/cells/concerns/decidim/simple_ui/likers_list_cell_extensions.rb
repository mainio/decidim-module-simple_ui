# frozen_string_literal: true

module Decidim
  module SimpleUi
    module LikersListCellExtensions
      extend ActiveSupport::Concern

      included do
        def full_likers
          @full_likers ||= base_relation
                           .map { |identity| present(identity.author) }
                           .grep_v(Decidim::NilPresenter)
        end
      end
    end
  end
end
