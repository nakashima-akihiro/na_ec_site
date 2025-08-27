Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
Stripe.api_version = '2025-07-30.basil'
