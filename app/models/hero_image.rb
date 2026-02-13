# frozen_string_literal: true

class HeroImage < ApplicationRecord
  has_one_attached :image

  validates :image, presence: true, on: :create
  validate :validate_max_count, on: :create

  scope :ordered, -> { order(position: :asc) }

  private

  def validate_max_count
    return if HeroImage.count < 5

    errors.add(:base, 'トップ画像は最大5枚まで登録できます')
  end
end
