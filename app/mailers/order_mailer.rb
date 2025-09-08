class OrderMailer < ApplicationMailer
  def complete(args)
    email = args[:email]
    # 環境変数からホスト名を取得
    @url  = ENV.fetch('DEFAULT_URL') { 'http://localhost:8000/orders' }
    mail(to: email, subject: 'Your order has been completed')
  end
end
