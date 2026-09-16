# frozen_string_literal: true

module Decidim
  module SimpleUi
    module ViewModelExtensions
      extend ActiveSupport::Concern

      included do
        # The cells gem (4.x) uses `caller(3, 1)` to determine the view name
        # when `render` is called without an explicit view argument. This assumes
        # the calling cell method is always exactly 3 stack frames above. When
        # cell templates use `content_tag` or `link_to` blocks, the extra frames
        # push the real method past frame 3, causing cells to look for templates
        # like `__tilt_XXXXX.erb` which don't exist.
        #
        # This override walks the call stack and finds the first frame from an
        # actual cell class file (*_cell.rb), which is always the correct method.
        def state_for_implicit_render(_options)
          caller.each do |frame|
            next unless frame.include?("_cell.rb:")

            match = frame.match(/`(\w+)'/)
            next unless match

            return match.captures.first
          end
          "show"
        end
      end
    end
  end
end
