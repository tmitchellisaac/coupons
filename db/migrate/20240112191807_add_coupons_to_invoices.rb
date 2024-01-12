class AddCouponsToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_reference :invoices, :coupon, foreign_key: true
  end
end
