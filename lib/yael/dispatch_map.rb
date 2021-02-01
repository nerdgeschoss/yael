# frozen_string_literal: true

module Yael
  class DispatchMap
    def initialize(block)
      @routes = []
      instance_eval(&block)
    end

    attr_reader :routes

    protected

    def dispatch(descriptor, to:, queue: :default, after: nil)
      @routes.push Route.new descriptor: descriptor, target: to, queue: queue, delay: after
    end
  end
end
