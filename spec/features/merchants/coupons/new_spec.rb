require "rails_helper"

describe "Coupons" do
  describe "new page" do
    it "has a link to a new coupon page with a form and it works" do
      merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)
      coupon_1 = merchant_1.coupons.create!(name: "15% off", uniq_code: "x95l", amt_off: 15, dollar_or_percent: "%", status: 1)
      coupon_2 = merchant_1.coupons.create!(name: "5_dollars_off", uniq_code: "ikm", amt_off: 5, dollar_or_percent: "$", status: 1)
      coupon_3 = merchant_1.coupons.create!(name: "10_dollars_off", uniq_code: "qaz", amt_off: 10, dollar_or_percent: "$", status: 1)
      coupon_4 = merchant_1.coupons.create!(name: "4_dollars_off", uniq_code: "wsx", amt_off: 4, dollar_or_percent: "$", status: 1)
      
      visit "/merchants/#{merchant_1.id}/coupons"
      click_link "New Coupon"
      expect(current_path).to eq("/merchants/#{merchant_1.id}/coupons/new")

      fill_in(:name, with: "$20 off")
      fill_in(:amt_off, with: "20")
      fill_in(:dollar_or_percent, with:"$")
      fill_in(:uniq_code, with:"qwer")
      click_button "Create New Coupon"

      expect(current_path).to eq("/merchants/#{merchant_1.id}/coupons")
      expect(page).to have_content("$20 off")
      expect(page).to have_content("20$")
      expect(page).to have_content("qwer")
      expect(Coupon.all.count).to eq 5
    end

    it "has a sad path for coupon creation if all required info not submitted" do
      merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)
      coupon_1 = merchant_1.coupons.create!(name: "15% off", uniq_code: "x95l", amt_off: 15, dollar_or_percent: "%", status: 1)
      coupon_2 = merchant_1.coupons.create!(name: "5_dollars_off", uniq_code: "ikm", amt_off: 5, dollar_or_percent: "$", status: 1)
      coupon_3 = merchant_1.coupons.create!(name: "10_dollars_off", uniq_code: "qaz", amt_off: 10, dollar_or_percent: "$", status: 1)
      coupon_4 = merchant_1.coupons.create!(name: "4_dollars_off", uniq_code: "wsx", amt_off: 4, dollar_or_percent: "$", status: 1)
      
      visit "/merchants/#{merchant_1.id}/coupons"
      click_link "New Coupon"
      expect(current_path).to eq("/merchants/#{merchant_1.id}/coupons/new")

      fill_in(:name, with: "$20 off")
      fill_in(:dollar_or_percent, with:"$")
      fill_in(:uniq_code, with:"qwer")
      click_button "Create New Coupon"

      expect(current_path).to eq("/merchants/#{merchant_1.id}/coupons/new")
      expect(page).to have_content("Not enough information to create, try again")
      expect(Coupon.all.count).to eq 4
    end
  end
end