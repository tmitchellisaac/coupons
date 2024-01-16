class RemoveDollarOrPercentFromCoupons < ActiveRecord::Migration[7.0]
  def change
    remove_column :coupons, :dollar_or_percent, :string
  end
end
