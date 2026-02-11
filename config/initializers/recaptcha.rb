Recaptcha.configure do |config|
  # 環境変数から読み込む（優先）
  # 設定されていない場合はRails credentialsから読み込む
  # どちらも設定されていない場合はnil（開発環境でreCAPTCHAが無効の場合）
  site_key = ENV['RECAPTCHA_SITE_KEY'] || Rails.application.credentials.dig(:recaptcha, :site_key)
  secret_key = ENV['RECAPTCHA_SECRET_KEY'] || Rails.application.credentials.dig(:recaptcha, :secret_key)
  
  if site_key.present? && secret_key.present?
    config.site_key = site_key
    config.secret_key = secret_key
  end
end
