# Stripe設定
# 環境変数から読み込む（優先）
# 設定されていない場合はRails credentialsから読み込む
secret_key = ENV['STRIPE_SECRET_KEY'] || Rails.application.credentials.dig(:stripe, :secret_key)

if secret_key.present?
  Stripe.api_key = secret_key
end

Stripe.api_version = '2025-07-30.basil'
