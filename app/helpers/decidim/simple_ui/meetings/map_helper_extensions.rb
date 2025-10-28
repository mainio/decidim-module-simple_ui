# frozen_string_literal: true

module Decidim
  module SimpleUi
    module Meetings
      module MapHelperExtensions
        extend ActiveSupport::Concern

        included do
          def meetings_data_for_map(meetings)
            geocoded_meetings = meetings.select(&:geocoded_and_valid?)
            geocoded_meetings.map do |meeting|
              meeting.slice(:latitude, :longitude, :address).merge(title: translated_attribute(meeting.title),
                                                                   description: strip_tags(translated_attribute(meeting.description)),
                                                                   link: resource_locator(meeting).path,
                                                                   items: cell("decidim/meetings/meeting_card_metadata", meeting).send(:meeting_items_for_map).to_json)
            end
          end
        end
      end
    end
  end
end
