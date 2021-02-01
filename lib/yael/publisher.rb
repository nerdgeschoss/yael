# frozen_string_literal: true

module Yael
  module Publisher
    extend ActiveSupport::Concern

    def publish(name, on: self, **payload)
      Yael::Bus.shared.dispatch(name, stream: on, payload: payload)
    end
  end
end
