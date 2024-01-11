require "spec_helper"

describe "Coupons" do
  describe "index page" do
    merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)
    coupon_1 = merchant_1.coupons.create(name: "15% off", uniq_code: "15%OFF", amt_off: 15, dollar_or_percent: 1)
    coupon_2 = merchant_1.coupons.create(name: "5_dollars_off", uniq_code: "$5OFF", amt_off: 5, dollar_or_percent: 0)
    coupon_3 = merchant_1.coupons.create(name: "10_dollars_off", uniq_code: "$10OFF", amt_off: 10, dollar_or_percent: 0)

    it "has an index page displaying all coupons for that merchant" do
    visit "/merchants/#{merchant_1.id}/dashboard"
    expect(page).to have_link("Coupons")
    click_link "Coupons"

    expect(current_path).to eq("/merchants/#{merchant_1.id}/coupons")
    expect(page).to have_content("15% off")
    expect(page).to have_content("5_dollars_off")
    expect(page).to have_content("10_dollars_off")

    expect(page).to have_content("15%")
    expect(page).to have_content("$5")
    expect(page).to have_content("$15")

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
end
