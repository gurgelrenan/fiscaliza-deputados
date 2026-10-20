Rails.application.config.x.posthog.tap do |config|
  config.project_key = ENV["POSTHOG_PROJECT_KEY"].presence
  config.api_host = ENV.fetch("POSTHOG_API_HOST", "https://us.i.posthog.com")
  config.enabled = ActiveModel::Type::Boolean.new.cast(
    ENV.fetch("POSTHOG_ENABLED", Rails.env.production?.to_s)
  ) && config.project_key.present?
end
