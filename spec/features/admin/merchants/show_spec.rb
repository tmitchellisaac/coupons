require 'rails_helper'

RSpec.describe 'Admin merchant show', type: :feature do
  describe '' do
    before(:each) do
      @merch_1 = Merchant.create!(name: "TJ MAX", status: :enabled)
      @merch_2 = Merchant.create!(name: "Target", status: :enabled)

      @item_1 = @merch_1.items.create!(name: "Apple", description: "red apple", unit_price:1)
      @item_2 = @merch_1.items.create!(name: "Orange", description: "orange orange", unit_price:1)

      @item_3 = @merch_2.items.create!(name: "Blood Orange", description: "blood orange", unit_price:1)
      @item_4 = @merch_2.items.create!(name: "Grape", description: "Red Grape", unit_price:1)

      @cust_1 = Customer.create!(first_name: "Larry", last_name: "Johnson")
      @cust_2 = Customer.create!(first_name: "Pam", last_name: "Nelson")
      @cust_3 = Customer.create!(first_name: "Logan", last_name: "Finnegan")
      @cust_4 = Customer.create!(first_name: "Nate", last_name: "Lambertson")
      @cust_5 = Customer.create!(first_name: "Martin", last_name: "chavez")
      @cust_6 = Customer.create!(first_name: "Isaac", last_name: "Mitchell")

      @inv_1 = @cust_1.invoices.create!(status: :completed, created_at:Time.new(2021, 10, 31) )
      @inv_2 = @cust_2.invoices.create!(status: :completed)
      @inv_3 = @cust_3.invoices.create!(status: :completed)
      @inv_4 = @cust_4.invoices.create!(status: :completed)
      @inv_5 = @cust_5.invoices.create!(status: :in_progress,created_at:Time.new(2024, 02, 1))
      @inv_6 = @cust_6.invoices.create!(status: :cancelled, created_at:Time.new(2021, 10, 31))

      @tran_1 = @inv_1.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "01/2021", result: :success )
      @tran_2 = @inv_2.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "02/2022", result: :success )
      @tran_3 = @inv_3.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "03/2023", result: :success )
      @tran_4 = @inv_4.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "04/2024", result: :success )
      @tran_5 = @inv_5.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "05/2025", result: :success )
      @tran_6 = @inv_6.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "06/2026", result: :failed )

      @ii_1 = InvoiceItem.create!(invoice: @inv_1, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
      @ii_2 = InvoiceItem.create!(invoice: @inv_1, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
      @ii_3 = InvoiceItem.create!(invoice: @inv_1, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
      @ii_4 = InvoiceItem.create!(invoice: @inv_2, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
      @ii_5 = InvoiceItem.create!(invoice: @inv_2, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
      @ii_6 = InvoiceItem.create!(invoice: @inv_2, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
      @ii_7 = InvoiceItem.create!(invoice: @inv_3, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
      @ii_8 = InvoiceItem.create!(invoice: @inv_3, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
      @ii_9 = InvoiceItem.create!(invoice: @inv_3, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
      @ii_10 = InvoiceItem.create!(invoice: @inv_4, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
      @ii_11 = InvoiceItem.create!(invoice: @inv_4, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
      @ii_12 = InvoiceItem.create!(invoice: @inv_4, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
      @ii_13 = InvoiceItem.create!(invoice: @inv_5, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
      @ii_14 = InvoiceItem.create!(invoice: @inv_5, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
      @ii_15 = InvoiceItem.create!(invoice: @inv_5, item: @item_3, quantity: 10, unit_price: 1, status: :pending )
      @ii_16 = InvoiceItem.create!(invoice: @inv_6, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
      @ii_17 = InvoiceItem.create!(invoice: @inv_6, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
      @ii_18= InvoiceItem.create!(invoice: @inv_6, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
      @ii_19 = InvoiceItem.create!(invoice: @inv_6, item: @item_4, quantity: 10, unit_price: 1, status: :pending )
    end

    # 25. Admin Merchant Show
    it 'clickable links on admin merchant' do
      # When I click on the name of a merchant from the admin merchants index page (/admin/merchants),
      visit admin_merchants_path
      within ".merchants-index" do
        click_link("#{@merch_1.name}")
      end

      # Then I am taken to that merchant's admin show page (/admin/merchants/:merchant_id)
      expect(current_path).to eq(admin_merchant_path(@merch_1))
      # And I see the name of that merchant
      expect(page).to have_content("Merchant: TJ MAX")
    end

    # 26. Admin Merchant Update
    it "can update merchant info" do
      visit admin_merchant_path(@merch_1)

      expect(page).to have_link("Update #{@merch_1.name} Info")

      click_link("Update #{@merch_1.name} Info")

      expect(current_path).to eq(edit_admin_merchant_path(@merch_1))
      expect(page).to have_field("Merchant Name:", with: "#{@merch_1.name}")

      fill_in "name", with: "Amazon"

      click_button("submit")

      expect(current_path).to eq(admin_merchant_path(@merch_1))
    
      expect(page).to have_content("Amazon")
      expect(page).to have_content("Update Successful")
      expect(@merch_1.status).to eq("enabled")
    end
  end
end
