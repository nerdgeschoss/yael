# frozen_string_literal: true

module Yael
  class Event < ActiveRecord::Base
    class << self
      def stream_for(object)
        "#{object.class.name.tableize}_#{object.id}"
      end
    end

    self.table_name = "yael_events"
  end
end
