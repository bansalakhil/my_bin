if Rails.env.development?
  google_app_client_id = Rails.application.secrets.google_app_client_id
  google_app_secret = Rails.application.secrets.google_app_secret
end

if Rails.env.production?
  google_app_client_id = ENV["GOOGLE_APP_CLIENT_ID"]
  google_app_secret = ENV["GOOGLE_APP_SECRET"]

end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, google_app_client_id, google_app_secret
end
