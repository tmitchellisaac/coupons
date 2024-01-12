require "rails_helper"

RSpec.describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:uniq_code) }
    it { should validate_presence_of(:amt_off) }
    it { should validate_presence_of(:dollar_or_percent) }
    it { should validate_presence_of(:status) }

  end

  describe "associations" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoices)}
  end

  it "has a unique ID that is valid" do
    merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)

    coupon_1 = merchant_1.coupons.create(name: "15% off", uniq_code: "loll", amt_off: 15, dollar_or_percent: "%", status: 1)
    coupon_2 = merchant_1.coupons.create(name: "5_dollars_off", uniq_code: "loll", amt_off: 5, dollar_or_percent: "$", status: 1)
      
    expect(coupon_1).to_not be_invalid
    expect(coupon_2).to be_invalid
  end

  it "can only create 5 active coupons per merchant" do
    merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)
    coupon_1 = merchant_1.coupons.create!(name: "15% off", uniq_code: "x95l", amt_off: 15, dollar_or_percent: "%", status: 1)
    coupon_2 = merchant_1.coupons.create!(name: "5_dollars_off", uniq_code: "ikm", amt_off: 5, dollar_or_percent: "$", status: 1)
    coupon_3 = merchant_1.coupons.create!(name: "10_dollars_off", uniq_code: "qaz", amt_off: 10, dollar_or_percent: "$", status: 1)
    coupon_4 = merchant_1.coupons.create!(name: "4_dollars_off", uniq_code: "wsx", amt_off: 4, dollar_or_percent: "$", status: 1)
    coupon_5 = merchant_1.coupons.create!(name: "1_dollars_off", uniq_code: "rfv", amt_off: 1, dollar_or_percent: "$", status: 1)
    
    coupon_6 = merchant_1.coupons.create(name: "6_dollars_off", uniq_code: "tgb", amt_off: 6, dollar_or_percent: "$", status: 1)
    
    expect(coupon_5).to be_valid
    expect(coupon_6).to be_invalid
  end
end
