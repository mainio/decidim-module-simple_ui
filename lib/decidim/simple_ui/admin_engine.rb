# frozen_string_literal: true

module Decidim
  module SimpleUi
    # This is the engine that runs on the public interface of `SimpleUi`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::SimpleUi::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :simple_ui do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "simple_ui#index"
      end

      def load_seed
        nil
      end
    end
  end
end
