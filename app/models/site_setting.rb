# frozen_string_literal: true

class SiteSetting < ApplicationRecord
  validates :postage, numericality: { greater_than_or_equal_to: 0 }
  validates :free_shipping_threshold, numericality: { greater_than_or_equal_to: 0 }

  # シングルトン: レコードが1件のみ存在する想定
  def self.instance
    first_or_create! do |setting|
      setting.postage = ENV.fetch('POSTAGE', 500).to_i
      setting.free_shipping_threshold = ENV.fetch('FREE_SHIPPING_THRESHOLD', 5000).to_i
    end
  end

  # 送料・送料無料閾値を取得（DB未準備時は環境変数またはデフォルト値）
  def self.postage
    return ENV.fetch('POSTAGE', 500).to_i unless table_exists?

    instance.postage
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordNotFound
    ENV.fetch('POSTAGE', 500).to_i
  end

  def self.free_shipping_threshold
    return ENV.fetch('FREE_SHIPPING_THRESHOLD', 5000).to_i unless table_exists?

    instance.free_shipping_threshold
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordNotFound
    ENV.fetch('FREE_SHIPPING_THRESHOLD', 5000).to_i
  end
end
