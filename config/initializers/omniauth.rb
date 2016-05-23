Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.secrets.google_app_client_id, Rails.application.secrets.google_app_secret
end