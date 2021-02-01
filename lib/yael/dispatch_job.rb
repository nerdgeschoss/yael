# frozen_string_literal: true

module Yael
  class DispatchJob < ActiveJob::Base
    retry_on ActiveRecord::Deadlocked

    queue_as :dispatch

    def perform(name:, stream:, payload:, created_at:, persist: true)
      event = Event.new id: SecureRandom.uuid, name: name, stream: stream, payload: payload, created_at: created_at
      event.save! if persist
      Yael::Bus.shared.process(event)
    end
  end
end
