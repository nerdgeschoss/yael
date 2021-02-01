# frozen_string_literal: true

require "rails/generators/base"

module Yael
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "This generator installs Yael"
      source_root File.expand_path("templates", __dir__)

      def copy_dispatch_map
        template "events.rb", "config/events.rb"
      end

      def copy_migration
        template "create_events.rb", "db/migrate/#{DateTime.current.strftime '%Y%m%d%H%M%S'}_create_yael_events.rb"
      end
    end
  end
end
