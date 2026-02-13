class Order < ApplicationRecord
  belongs_to :customer, optional: true
  validate :customer_or_guest_email_present

  enum status: {
    waiting_payment: 0,
    confirm_payment: 1,
    shipped: 2,
    out_of_delivery: 3,
    delivered: 4
  }
  has_many :order_details, dependent: :destroy

  scope :waiting_payment, -> { where(status: 'waiting_payment') }
  scope :confirm_payment, -> { where(status: 'confirm_payment') }
  scope :shipped, -> { where(status: 'shipped') }
  scope :out_of_delivery, -> { where(status: 'out_of_delivery') }
  scope :delivered, -> { where(status: 'delivered') }

  scope :created_today, -> { where('orders.created_at >= ?', Time.zone.now.beginning_of_day) }

  def display_email
    customer&.email || guest_email
  end

  private

  def customer_or_guest_email_present
    return if customer_id.present? || guest_email.present?

    errors.add(:base, '顧客またはゲストメールが必要です')
  end
end
