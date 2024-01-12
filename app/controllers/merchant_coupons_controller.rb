class MerchantCouponsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @coupons = @merchant.coupons
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.create(strong_params)
    
    redirect_to "/merchants/#{merchant.id}/coupons"
  end



  private

  def strong_params
      params.permit(:id, :name, :uniq_code, :amt_off, :status, :merchant_id, :dollar_or_percent)
  end

end