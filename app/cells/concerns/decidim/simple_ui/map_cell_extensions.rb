# frozen_string_literal: true

module Decidim
  module SimpleUi
    module MapCellExtensions
      extend ActiveSupport::Concern

      included do
        private

        if Decidim.module_installed?(:meetings_locations)
          def data_for_map
            model.filter_map do |record|
              if record.is_a?(Decidim::Meetings::Meeting)
                next if record.locations.blank?
              else
                next unless record.geocoded_and_valid?
              end

              extra = if record.is_a?(Decidim::Meetings::Meeting)
                        { description: strip_tags(translated_attribute(record.description)) }
                      elsif record.is_a?(Decidim::Proposals::Proposal)
                        { body: decidim_html_escape(present(record).body) }
                      end

              record.slice(:latitude, :longitude, :address)
                    .merge(
                      title: record.presenter.title,
                      link: resource_locator(record).path,
                      items: cell(options[:metadata_card], record).send(:items_for_map).to_json
                    )
                    .merge(extra)
            end
          end
        else
          def data_for_map
            data = model.select(&:geocoded_and_valid?)
            data.map do |record|
              extra = if record.is_a?(Decidim::Meetings::Meeting)
                        { description: strip_tags(translated_attribute(record.description)) }
                      elsif record.is_a?(Decidim::Proposals::Proposal)
                        { body: decidim_html_escape(present(record).body) }
                      else
                        {}
                      end

              record.slice(:latitude, :longitude, :address)
                    .merge(
                      title: record.presenter.title,
                      link: resource_locator(record).path,
                      items: cell(options[:metadata_card], record).send(:items_for_map).to_json
                    )
                    .merge(extra)
            end
          end
        end
      end
    end
  end
end
