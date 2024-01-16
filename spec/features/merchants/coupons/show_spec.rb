require "rails_helper"

describe "Coupons" do
  describe "new page" do
    it "displays name, code, amt_off, status and count of use for a coupon" do
      merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)
      coupon_1 = merchant_1.coupons.create!(name: "15% off", uniq_code: "x95l", amt_off: 15, dollar_or_percent: 1, status: 1)
      coupon_2 = merchant_1.coupons.create!(name: "5_dollars_off", uniq_code: "ikm", amt_off: 5, dollar_or_percent: 0, status: 1)
      coupon_3 = merchant_1.coupons.create!(name: "10_dollars_off", uniq_code: "qaz", amt_off: 10, dollar_or_percent: 0, status: 1)
      coupon_4 = merchant_1.coupons.create!(name: "4_dollars_off", uniq_code: "wsx", amt_off: 4, dollar_or_percent: 0, status: 1)
      
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
      
      visit "/merchants/#{merchant_1.id}/coupons/#{coupon_2.id}"
      expect(page).to have_content("5_dollars_off")
      expect(page).to have_content("ikm")
      expect(page).to have_content("5$")
      expect(page).to have_content("Active")

      within "#usage" do
        expect(page).to have_content(3)
      end
    end

    it "has a button to activate/deactive a coupon" do
      merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)
      coupon_1 = merchant_1.coupons.create!(name: "15% off", uniq_code: "x95l", amt_off: 15, dollar_or_percent: 1, status: 1)
      coupon_2 = merchant_1.coupons.create!(name: "5_dollars_off", uniq_code: "ikm", amt_off: 5, dollar_or_percent: 1, status: 1)
      coupon_3 = merchant_1.coupons.create!(name: "10_dollars_off", uniq_code: "qaz", amt_off: 10, dollar_or_percent: 1, status: 1)
      coupon_4 = merchant_1.coupons.create!(name: "4_dollars_off", uniq_code: "wsx", amt_off: 4, dollar_or_percent: 1, status: 0)
      
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
      invoice2 = customer1.invoices.create!(status: 1, coupon_id: coupon_1.id)
      invoice4 = customer1.invoices.create!(status: 2, coupon_id: coupon_4.id)

      invoice3 = customer1.invoices.create!(status: 2, coupon_id: coupon_2.id)

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
      
      visit "/merchants/#{merchant_1.id}/coupons/#{coupon_2.id}"
      expect(page).to have_content("Active")
      click_button "Disable coupon"
      expect(current_path).to eq("/merchants/#{merchant_1.id}/coupons/#{coupon_2.id}")
      expect(page).to have_content("Inactive")

      visit "/merchants/#{merchant_1.id}/coupons/#{coupon_1.id}"
      expect(page).to have_content("Active")
      click_button "Disable coupon"
      expect(current_path).to eq("/merchants/#{merchant_1.id}/coupons/#{coupon_1.id}")
      expect(page).to have_content("Active")
      expect(page).to have_content("Cannot disable coupon due to pending invoice")

      visit "/merchants/#{merchant_1.id}/coupons/#{coupon_4.id}"
      expect(page).to have_content("Inactive")
      click_button "Activate coupon"
      expect(current_path).to eq("/merchants/#{merchant_1.id}/coupons/#{coupon_4.id}")
      expect(page).to have_content("Active")
    end

  end
end
