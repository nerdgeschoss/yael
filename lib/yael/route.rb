# frozen_string_literal: true

module Yael
  class Route
    attr_reader :descriptor, :target, :queue, :delay

    def initialize(descriptor:, target:, queue: :default, delay: nil)
      @descriptor = descriptor
      @target = target
      @queue = queue
      @delay = delay
      @target_name = target.split(".").first.classify
      @target_method = target.split(".").second
    end

    def matches?(stream)
      return true if descriptor == :all

      descriptor.to_s == stream
    end

    def dispatch(event)
      method = target_method || "on_#{event.name}"
      args = event.payload.symbolize_keys
      ExecutionJob.set(queue: queue, wait: delay).perform_later(target_name, method, event.stream, args)
    end

    private

    attr_reader :target_name, :target_method
  end
end
