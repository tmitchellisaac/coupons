require 'rails_helper'

RSpec.describe 'Admin Show Spec', type: :feature do
  describe 'as an admin' do
    before(:each) do
      @merch_1 = Merchant.create!(name: "Walmart", status: :enabled)
      @merch_2 = Merchant.create!(name: "Target", status: :disabled)
      @merch_3 = Merchant.create!(name: "PetSmart", status: :disabled)
      @merch_4 = Merchant.create!(name: "GameStop", status: :enabled)
      @merch_5 = Merchant.create!(name: "Sams", status: :enabled)
      @merch_6 = Merchant.create!(name: "Costco", status: :enabled)

      @item_1 = @merch_1.items.create!(name: "Apple", description: "red apple", unit_price:1)
      @item_2 = @merch_1.items.create!(name: "Orange", description: "orange orange", unit_price:1)
      @item_3 = @merch_2.items.create!(name: "Blood Orange", description: "blood orange", unit_price:1)
      @item_4 = @merch_2.items.create!(name: "Grape", description: "Red Grape", unit_price:1)
      @item_5 = @merch_3.items.create!(name: "Dragon fruit", description: "Red", unit_price:1)
      @item_6 = @merch_3.items.create!(name: "plum", description: "Good", unit_price:1)
      @item_7 = @merch_4.items.create!(name: "tacos", description: "tortilla", unit_price:1)
      @item_8 = @merch_4.items.create!(name: "gum", description: "mint", unit_price:1)
      @item_9 = @merch_5.items.create!(name: "pasta", description: "Italian", unit_price:1)
      @item_10 = @merch_5.items.create!(name: "Rum", description: "Yum", unit_price:1)
      @item_11 = @merch_6.items.create!(name: "Vodka", description: "White", unit_price:1)
      @item_12 = @merch_6.items.create!(name: "Cat Toy", description: "toy", unit_price:1)

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

      @ii_1 = InvoiceItem.create!(invoice: @inv_1, item: @item_1, quantity: 10, unit_price: 1000, status: :shipped )
      @ii_2 = InvoiceItem.create!(invoice: @inv_1, item: @item_2, quantity: 10, unit_price: 1000, status: :shipped )
      @ii_3 = InvoiceItem.create!(invoice: @inv_1, item: @item_3, quantity: 10, unit_price: 1000, status: :shipped )
      @ii_4 = InvoiceItem.create!(invoice: @inv_2, item: @item_1, quantity: 10, unit_price: 1000, status: :shipped )
      @ii_5 = InvoiceItem.create!(invoice: @inv_2, item: @item_2, quantity: 10, unit_price: 1000, status: :shipped )
      @ii_6 = InvoiceItem.create!(invoice: @inv_2, item: @item_3, quantity: 10, unit_price: 1000, status: :shipped )
    end

    # 33. Admin Invoice Show Page
    it 'shows invoice data' do
      # When I visit an admin invoice show page (/admin/invoices/:invoice_id)
      visit  admin_invoice_path(@inv_1)
      # Then I see information related to that invoice including:
      # - Invoice id
      # - Invoice status
      # - Invoice created_at date in the format "Monday, July 18, 2019"
      # - Customer first and last name
      expect(page).to have_content(@inv_1.id)
      expect(page).to have_content(@inv_1.status)
      expect(page).to have_content(@inv_1.created_at.strftime("%A, %B %d, %Y"))
      expect(page).to have_content("#{@inv_1.customer.first_name} #{@inv_1.customer.last_name}")
    end

    it "Update invoice status" do
      visit admin_invoice_path(@inv_3)

      within ".status-update" do
        select("completed", from: "status")
        click_button "Update"

        expect(current_path).to eq(admin_invoice_path(@inv_3))
        expect(page).to have_content("Current Status: completed")
        expect(page).to_not have_content("Update Successful")

        select("cancelled", from: "status")
        click_button "Update"

        expect(current_path).to eq(admin_invoice_path(@inv_3))
        expect(page).to have_content("Current Status: cancelled")
        expect(page).to_not have_content("Update Successful")

        select("in progress", from: "status")
        click_button "Update"

        expect(current_path).to eq(admin_invoice_path(@inv_3))
        expect(page).to have_content("Current Status: in_progress")
        expect(page).to_not have_content("Update Successful")
      end
    end

    # 34. Admin Invoice Show Page: Invoice Item Information
    it "displays item info" do
      # When I visit an admin invoice show page (/admin/invoices/:invoice_id)
      visit admin_invoice_path(@inv_1)
      # Then I see all of the items on the invoice including:
      # - Item name
      # - The quantity of the item ordered
      # - The price the Item sold for
      # - The Invoice Item status
      within "#item-details-#{@item_1.id}" do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@ii_1.quantity)
        expect(page).to have_content(@item_1.unit_price)
        expect(page).to have_content(@ii_1.status)
      end

      within "#item-details-#{@item_2.id}" do
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@ii_2.quantity)
        expect(page).to have_content(@item_2.unit_price)
        expect(page).to have_content(@ii_2.status)
      end

      within "#item-details-#{@item_3.id}" do
        expect(page).to have_content(@item_3.name)
        expect(page).to have_content(@ii_1.quantity)
        expect(page).to have_content(@item_3.unit_price)
        expect(page).to have_content(@ii_3.status)
      end
    end

    it 'Shows an invoices total revenue' do
      visit admin_invoice_path(@inv_1)
      expect(page).to have_content("$300.00")
    end


    it "has a something method idk fill it in later" do
      merchant_11 = Merchant.create!(name: "Walmart", status: :enabled)
      merchant_22 = Merchant.create!(name: "Temu")
      
      coupon_11 = merchant_11.coupons.create!(name: "15% off", uniq_code: "x95l", amt_off: 25, dollar_or_percent: "percent", status: 1)
      coupon_22 = merchant_11.coupons.create!(name: "5_dollars_off", uniq_code: "ikm", amt_off: 500, dollar_or_percent: "dollars", status: 1)
      
      item11 = merchant_11.items.create!(name: "popcan", description: "fun", unit_price: 200)
      item22 = merchant_11.items.create!(name: "popper", description: "fun", unit_price: 200)
      item33 = merchant_22.items.create!(name: "copper", description: "money", unit_price: 300)
      
      customer11 = Customer.create!(first_name: "John", last_name: "Smith")
      customer22 = Customer.create!(first_name: "Jane", last_name: "Sornes")
      
      invoice11 = Invoice.create!(customer_id: customer11.id, coupon_id: coupon_22.id, status: 2)
      invoice22 = customer22.invoices.create!(status: 2)
      
      invoice_item11 = invoice11.invoice_items.create!(item_id: item11.id, quantity: 1, unit_price: 200, status: 2)
      invoice_item22 = invoice11.invoice_items.create!(item_id: item22.id, quantity: 1, unit_price: 200, status: 2)
      invoice_item33 = invoice11.invoice_items.create!(item_id: item33.id, quantity: 1, unit_price: 300, status: 2)
      
      # 8. Admin Invoice Show Page: Subtotal and Grand Total Revenues

      # As an admin
      # When I visit one of my admin invoice show pages
      # I see the name and code of the coupon that was used (if there was a coupon applied)
      # And I see both the subtotal revenue from that invoice (before coupon) and 
      # the grand total revenue (after coupon) for this invoice.

      # * Alternate Paths to consider: 
      # 1. There may be invoices with items from more than 1 merchant. 
      # Coupons for a merchant only apply to items from that merchant.
      # 2. When a coupon with a dollar-off value is used with an invoice with 
      # multiple merchants' items, the dollar-off amount applies to the total amount even 
      # though there may be items present from another merchant.
         
      visit admin_invoice_path(invoice11)
      expect(page).to have_content("Total Revenue: $7.00")
      expect(page).to have_content("ikm")
      expect(page).to have_content("Grand Total Revenue: $3.00")
    end
  end
end
