require "rails_helper"

describe "Coupons" do
  describe "index page" do
    it "has an index page displaying all coupons for that merchant" do
    merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)
    coupon_1 = merchant_1.coupons.create!(name: "15% off", uniq_code: "x95l", amt_off: 15, dollar_or_percent: "%", status: 1)
    coupon_2 = merchant_1.coupons.create!(name: "5_dollars_off", uniq_code: "ikm", amt_off: 5, dollar_or_percent: "$", status: 1)
    coupon_3 = merchant_1.coupons.create!(name: "10_dollars_off", uniq_code: "qaz", amt_off: 10, dollar_or_percent: "$", status: 1)
    coupon_4 = merchant_1.coupons.create!(name: "4_dollars_off", uniq_code: "wsx", amt_off: 4, dollar_or_percent: "$", status: 1)
    coupon_5 = merchant_1.coupons.create!(name: "1_dollars_off", uniq_code: "rfv", amt_off: 1, dollar_or_percent: "$", status: 1)
    # coupon_6 = merchant_1.coupons.create!(name: "6_dollars_off", uniq_code: "tgb", amt_off: 6, dollar_or_percent: "$", status: 1)
   
    visit "/merchants/#{merchant_1.id}/dashboard"
    expect(page).to have_link("Coupons")
    click_link "Coupons"

    expect(current_path).to eq("/merchants/#{merchant_1.id}/coupons")
    expect(page).to have_content("15% off")
    expect(page).to have_content("5_dollars_off")
    expect(page).to have_content("10_dollars_off")

    expect(page).to have_content("15%")
    expect(page).to have_content("5$")
    expect(page).to have_content("10$")

    click_link "15% off"
    expect(current_path).to eq(("/merchants/#{merchant_1.id}/coupons/#{coupon_1.id}"))
    
    visit "/merchants/#{merchant_1.id}/coupons"
    click_link "5_dollars_off"
    expect(current_path).to eq(("/merchants/#{merchant_1.id}/coupons/#{coupon_2.id}"))

    visit "/merchants/#{merchant_1.id}/coupons"
    click_link "10_dollars_off"
    expect(current_path).to eq(("/merchants/#{merchant_1.id}/coupons/#{coupon_3.id}"))

    end
  end

  it "separates active and inactive coupons on the index page" do
    merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)
    coupon_1 = merchant_1.coupons.create!(name: "15% off", uniq_code: "x95l", amt_off: 15, dollar_or_percent: "%", status: 1)
    coupon_2 = merchant_1.coupons.create!(name: "5_dollars_off", uniq_code: "ikm", amt_off: 5, dollar_or_percent: "$", status: 1)
    coupon_3 = merchant_1.coupons.create!(name: "10_dollars_off", uniq_code: "qaz", amt_off: 10, dollar_or_percent: "$", status: 1)
    coupon_4 = merchant_1.coupons.create!(name: "4_dollars_off", uniq_code: "wsx", amt_off: 4, dollar_or_percent: "$", status: 0)
    coupon_5 = merchant_1.coupons.create!(name: "1_dollars_off", uniq_code: "rfv", amt_off: 1, dollar_or_percent: "$", status: 0)
    
    visit "/merchants/#{merchant_1.id}/coupons"

    within "#active" do
      expect(page).to have_content("15% off")
      expect(page).to have_content("5_dollars_off")
      expect(page).to have_content("10_dollars_off")
    end

    within "#inactive" do
      expect(page).to have_content("4_dollars_off")
      expect(page).to have_content("1_dollars_off")
    end
  end

end
