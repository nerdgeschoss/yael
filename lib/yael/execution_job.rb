# frozen_string_literal: true

module Yael
  class ExecutionJob < ActiveJob::Base
    retry_on ActiveRecord::Deadlocked

    def perform(target_name, method, stream, args)
      target_constant = target_name.constantize
      parameters = extract_parameters(target_constant.method(method), stream, args)
      target_constant.public_send method, **parameters
    end

    private

    def extract_parameters(method, stream, args)
      requested = method.parameters.select { |e| e.first == :keyreq }.map(&:second)
      args.merge!(stream: stream) if requested.include?(:stream)
      args.merge!(publisher: publisher_for(stream: stream)) if requested.include?(:publisher)
      args.slice(*requested)
    end

    def publisher_for(stream:)
      table, _, id = stream.partition "_"
      table.classify.constantize.find(id)
    end
  end
end
