class Coupon < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  validates :uniq_code, presence: true
  validates :amt_off, presence: true
  validates :dollar_or_percent, presence: true

end