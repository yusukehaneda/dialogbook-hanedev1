# Dockerビルド時（assets:precompile）は RAILS_MASTER_KEY が利用できないため
# credentials が読めない場合はミドルウェア登録をスキップする
if (auth0 = Rails.application.credentials.auth0).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :auth0,
             auth0.client_id,
             auth0.client_secret,
             auth0.domain,
             callback_path: "/auth/auth0/callback",
             scope: "openid email profile"

    OmniAuth.config.on_failure =
      Proc.new { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }
  end
end
