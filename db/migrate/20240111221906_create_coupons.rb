class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :uniq_code
      t.integer :amt_off
      t.string :dollar_or_percent
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
