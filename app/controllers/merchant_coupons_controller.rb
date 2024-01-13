class MerchantCouponsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    # @coupons = @merchant.coupons
    @active_coupons = @merchant.active_coupons
    @inactive_coupons = @merchant.inactive_coupons
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
    @count = @coupon.usage
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.new(strong_params)
    
      if coupon.save
        redirect_to "/merchants/#{merchant.id}/coupons"
        flash[:alert] = "Coupon created successfully"
      else
        flash[:alert] = "Not enough information to create, try again"
        redirect_to "/merchants/#{merchant.id}/coupons/new"
      end

  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    coupon = Coupon.find(params[:id])
      if coupon.pending_invoice?
        coupon.update(strong_params)
      else
        flash[:alert] = "Cannot disable coupon due to pending invoice"
      end
    redirect_to "/merchants/#{merchant.id}/coupons/#{coupon.id}"
  end



  private

  def strong_params
      params.permit(:id, :name, :uniq_code, :amt_off, :status, :merchant_id, :dollar_or_percent)
  end

end