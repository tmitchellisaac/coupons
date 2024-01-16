class AddDollarOrPercentToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :dollar_or_percent, :integer
  end
end
