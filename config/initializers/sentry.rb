Sentry.init do |config|
    config.dsn = 'https://9682e4544eb540369794b55a50d63f5c@o82964.ingest.sentry.io/4503944325365760'
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  
    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = 1.0
  end
