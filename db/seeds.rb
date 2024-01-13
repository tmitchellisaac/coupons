# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Customer.destroy_all
Merchant.destroy_all
Invoice.destroy_all
Item.destroy_all
Transaction.destroy_all
InvoiceItem.destroy_all

merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)
coupon_1 = merchant_1.coupons.create!(name: "15% off", uniq_code: "x95l", amt_off: 15, dollar_or_percent: "%", status: 1)
coupon_2 = merchant_1.coupons.create!(name: "5_dollars_off", uniq_code: "ikm", amt_off: 5, dollar_or_percent: "$", status: 1)
coupon_3 = merchant_1.coupons.create!(name: "10_dollars_off", uniq_code: "qaz", amt_off: 10, dollar_or_percent: "$", status: 1)
coupon_4 = merchant_1.coupons.create!(name: "4_dollars_off", uniq_code: "wsx", amt_off: 4, dollar_or_percent: "$", status: 1)

item1 = merchant_1.items.create!(name: "popcan", description: "fun", unit_price: 100)
item2 = merchant_1.items.create!(name: "popper", description: "fun", unit_price: 156)
item3 = merchant_1.items.create!(name: "zipper", description: "pants", unit_price: 340)
item4 = merchant_1.items.create!(name: "zoozah", description: "doot", unit_price: 354)
item5 = merchant_1.items.create!(name: "oiko", description: "zeelk", unit_price: 4)
item6 = merchant_1.items.create!(name: "onion pillow", description: "kids", unit_price: 1030)
item7 = merchant_1.items.create!(name: "stash", description: "costume", unit_price: 1070)

customer1 = Customer.create!(first_name: "John", last_name: "Smith")
customer2 = Customer.create!(first_name: "Jane", last_name: "Sornes")
customer3 = Customer.create!(first_name: "Jaques", last_name: "Snipes")

invoice1 = customer1.invoices.create!(status: 2, coupon_id: coupon_2.id)
invoice2 = customer1.invoices.create!(status: 2, coupon_id: coupon_2.id)
invoice3 = customer1.invoices.create!(status: 2, coupon_id: coupon_2.id)
invoice4 = customer1.invoices.create!(status: 2, coupon_id: coupon_2.id)

invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 100, status: 2)
invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 1, unit_price: 100, status: 2)
invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 100, status: 2)
invoice_item4 = invoice2.invoice_items.create!(item_id: item4.id, quantity: 1, unit_price: 10, status: 2)
invoice_item5 = invoice2.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 10, status: 2)
invoice_item6 = invoice2.invoice_items.create!(item_id: item6.id, quantity: 1, unit_price: 10, status: 2)
invoice_item6 = invoice3.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 100, status: 2)
invoice_item6 = invoice3.invoice_items.create!(item_id: item2.id, quantity: 1, unit_price: 100, status: 2)
invoice_item6 = invoice3.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 100, status: 2)
invoice_item6 = invoice4.invoice_items.create!(item_id: item4.id, quantity: 1, unit_price: 10, status: 2)
invoice_item6 = invoice4.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 10, status: 2)
invoice_item6 = invoice4.invoice_items.create!(item_id: item6.id, quantity: 1, unit_price: 10, status: 2)

transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/26", result: 0)
transaction3 = invoice3.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/26", result: 0)
transaction4 = invoice4.transactions.create!(credit_card_number: 7987654321098765, credit_card_expiration_date: "5/30", result: 1)

