# frozen_string_literal: true

module Yael
  class ExecutionJob < ActiveJob::Base
    retry_on ActiveRecord::Deadlocked

    def perform(target_name, method, args)
      target_constant = target_name.constantize
      parameters = extract_parameters(target_constant.method(method), args)
      target_constant.public_send method, **parameters
    end

    private

    def extract_parameters(method, args)
      requested = method.parameters.select { |e| e.first == :keyreq }.map(&:second)
      args.slice(*requested)
    end
  end
end
