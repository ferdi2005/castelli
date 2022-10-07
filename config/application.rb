require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Castelli
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_job.queue_adapter = :sidekiq
    config.time_zone = "Europe/Rome"

    Sentry.init do |config|
      config.dsn = 'https://9682e4544eb540369794b55a50d63f5c@o82964.ingest.sentry.io/4503944325365760'
      config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    
      # Set traces_sample_rate to 1.0 to capture 100%
      # of transactions for performance monitoring.
      # We recommend adjusting this value in production.
      config.traces_sample_rate = 1.0
    end
  end
end
