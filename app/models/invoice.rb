class Invoice < ApplicationRecord
  validates :status, presence: true

  belongs_to :coupon, optional: true
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: { in_progress: 0, cancelled: 1, completed: 2 }

  def self.best_day
    self.joins(:invoice_items)
      .select("SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue, invoices.created_at")
      .group(:id)
      .order("revenue DESC")
      .first
  end


  def total_revenue
    self.invoice_items.joins(:item)
      .sum("invoice_items.quantity * invoice_items.unit_price")
  end


  def grand_total
    merch_id = self.coupon.merchant.id
    total = (InvoiceItem.find_by_sql ["
    SELECT sum(invoice_items.quantity * invoice_items.unit_price)
    FROM items
    JOIN invoice_items ON items.id = invoice_items.item_id
    WHERE items.merchant_id = #{merch_id} AND
    invoice_items.invoice_id = #{id}
    "]).first.sum
    amt_off = dollar_coupon_invoice
    if total - amt_off <= 0
      final_discount = total 
    elsif total - amt_off > 0
      final_discount = amt_off
    end
    total_revenue - final_discount
  end

  def dollar_coupon_invoice
    Coupon.joins(:invoices).where("coupons.dollar_or_percent = ?", 0).where("invoices.id = #{self.id}").pluck(:amt_off).first
  end




  def coupon_code
    Invoice.joins(:coupon).where("invoices.id = #{id}").pluck(:uniq_code).first
  end

end
