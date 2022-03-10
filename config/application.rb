require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsMyApp
  class Application < Rails::Application
    root_path = Rails.root.to_s
    APP_PATH = '/app/'.freeze
    add_folders = %w[forms view_models services queries]

    add_folders.each do |add_folder|
      require_parent_folder = "#{root_path}#{APP_PATH}#{add_folder}"
      require_folders = Dir.glob([require_parent_folder, "#{require_parent_folder}/*"])

      require_folders.each do |require_folder|
        config.autoload_paths << require_folder
        require_files = Dir["#{require_folder}/*.rb"]
        require_files.sort.each { |require_file| require require_file }
      end
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.i18n.default_locale = :ja

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       controller_specs: false,
                       routing_specs: false,
                       request_specs: false
    end

    # 認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
