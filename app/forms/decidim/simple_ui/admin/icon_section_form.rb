# frozen_string_literal: true

module Decidim
  module SimpleUi
    module Admin
      class IconSectionForm < Form
        include TranslatableAttributes

        translatable_attribute :title, String
        translatable_attribute :description, String
        attribute :icon, String
        attribute :position, Integer
        attribute :deleted, Boolean, default: false

        validates :title, :description, translatable_presence: true, unless: :deleted
        validates :icon, inclusion: { in: :available_icons }

        def to_param
          return id if id.present?

          "icon-section-id"
        end

        def self.available_icons
          @available_icons ||= %w(
            lightbulb-flash-line
            settings-2-line
            checkbox-multiple-line
            eye-line
            login-box-line
            discuss-line
            map-pin-line
            pencil-line
            calendar-line
            like
            share
          )
        end
      end
    end
  end
end
