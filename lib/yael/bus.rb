# frozen_string_literal: true

module Yael
  class Bus
    class << self
      def shared
        unless @shared
          @shared = Bus.new
          path = Rails.root.join("config/events.rb")
          if path.exist?
            reloader = Rails.configuration.file_watcher.new([path]) do
              load path
            end
            Rails.application.reloader.to_prepare do
              reloader.execute_if_updated
            end
            Rails.application.reloaders << reloader
            reloader.execute
          end
        end
        @shared
      end
    end

    def routes
      @routes ||= []
    end

    def routing(&block)
      @routes = DispatchMap.new(block).routes
    end

    def dispatch(name, stream:, payload:)
      stream = Event.stream_for(stream) unless stream.is_a?(String)
      DispatchJob.perform_later(name: name, stream: stream, payload: payload, created_at: DateTime.current)
    end

    def process(event)
      routes.each do |route|
        route.dispatch(event) if route.matches? event.name
      end
    end
  end
end
