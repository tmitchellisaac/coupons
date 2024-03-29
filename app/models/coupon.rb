class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices
  has_many :transactions, through: :invoices
  validates :name, presence: true
  validates :uniq_code, uniqueness: true
  validates :uniq_code, presence: true

  validates :amt_off, presence: true
  validates :dollar_or_percent, presence: true
  validates :status, presence: true

 
  validate :limit_inactive_coupons, on: :create
  enum dollar_or_percent: {dollars: 0, percent: 1}
  enum status: {inactive: 0, active: 1}

  # def usage
  #   Coupon.find_by_sql ["
  #     SELECT count(invoices.coupon_id) AS coupon_count
  #     FROM invoices
  #     JOIN transactions ON invoices.id = transactions.invoice_id
  #     WHERE transactions.result = 0 AND
  #     invoices.coupon_id = #{self.id}
  #     GROUP BY invoices.coupon_id
  #   "]
  # end

  def usage
    Invoice.joins(:transactions)
    .where(transactions: { result: 0 }, coupon_id: id)
    .count
  end

  def pending_invoice?
    Invoice.where("#{id} = invoices.coupon_id").where(status: 1).empty?
  end

  def converter
    if self.dollar_or_percent == "percent"
      "%"
    elsif self.dollar_or_percent == "dollars"
      "$"
    end
  end

  # put these in the merchant model instead
  
  # def active_coupons
  #   self.coupons.where({coupons: {status: 1}})
  # end

  # def inactive_coupons
  #   self.coupons.where({coupons: {status: 0}})
  # end

  private

  def limit_inactive_coupons
    max_inactive_coupons = 5 
    return unless merchant.present?
    if merchant.coupons.where(status: 1).count >= max_inactive_coupons
      errors.add(:base, "Exceeded the limit of inactive coupons")
    end
  end



end