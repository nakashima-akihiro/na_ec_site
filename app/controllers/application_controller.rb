class ApplicationController < ActionController::Base
  if ENV.fetch('BASIC_AUTH_ENABLED', 'false') == 'true'
    http_basic_authenticate_with(
      name: ENV.fetch('BASIC_AUTH_USERNAME', 'admin'),
      password: ENV.fetch('BASIC_AUTH_PASSWORD', 'password'),
      unless: ->(controller) { controller.controller_path == 'customer/webhooks' }
    )
  end
end
