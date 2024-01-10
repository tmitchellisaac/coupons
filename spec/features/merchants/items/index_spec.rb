require "rails_helper"

RSpec.describe "Merchants/Items Index Page", type: :feature do
  it "shows a list of all of my items and not for other merchants" do
    merchant_1 = Merchant.create!(name: "Walmart", status: :enabled)
    merchant_2 = Merchant.create!(name: "Amazon", status: :enabled)
    walmart_items = create_list(:item, 37, merchant_id: merchant_1.id)
    amazon_items = create_list(:item, 43, merchant_id: merchant_2.id)

    visit "/merchants/#{merchant_1.id}/items"

    walmart_items.each do |walmart_item|
      expect(page).to have_content(walmart_item.name)
    end

    amazon_items.each do |amazon_item|
      expect(page).to_not have_content(amazon_item.name)
    end

    visit "/merchants/#{merchant_2.id}/items"

    amazon_items.each do |amazon_item|
      expect(page).to have_content(amazon_item.name)
    end

    walmart_items.each do |walmart_item|
      expect(page).to_not have_content(walmart_item.name)
    end
  end

  it "has a disable/enable status and a link to change status next to each item" do
    merchant_1 = Merchant.create!(name: "Walmart")
    merchant_2 = Merchant.create!(name: "Amazon")
    walmart_items = create_list(:item, 37, merchant_id: merchant_1.id)
    amazon_items = create_list(:item, 43, merchant_id: merchant_2.id)

    visit "/merchants/#{merchant_1.id}/items"

    within "#item-#{merchant_1.items.first.id}" do
      expect(page).to have_content("enabled")
      expect(page).to have_button("enable")
      expect(page).to have_button("disable")
    end

    within "#item-#{merchant_1.items.last.id}" do
      expect(page).to have_content("enabled")
      expect(page).to have_button("enable")
      expect(page).to have_button("disable")

      click_button "disable"
    end

    expect(current_path).to eq("/merchants/#{merchant_1.id}/items")
    expect(merchant_1.items.last.status).to eq("disabled")
    within "#item-#{merchant_1.items.last.id}" do
      expect(page).to have_content("disabled")
    end

    within "#item-#{merchant_1.items.last.id}" do
      expect(page).to have_content("disabled")
      expect(page).to have_button("enable")
      expect(page).to have_button("disable")

      click_button "enable"
    end

    expect(current_path).to eq("/merchants/#{merchant_1.id}/items")
    expect(merchant_1.items.last.status).to eq("enabled")
    within "#item-#{merchant_1.items.last.id}" do
      expect(page).to have_content("enabled")
    end
  end

  it "has two sections, one for 'Enabled Items' and one for 'Disabled Items'" do
    merchant = Merchant.create!(name: "Snow-Globes and Used Clothing")
    items1 = create_list(:item, 23, merchant_id: merchant.id, status: "enabled")
    items2 = create_list(:item, 17, merchant_id: merchant.id, status: "disabled")
    items3 = create_list(:item, 11, merchant_id: merchant.id, status: "enabled")
    items4 = create_list(:item, 13, merchant_id: merchant.id, status: "disabled")

    visit "/merchants/#{merchant.id}/items"

    within('section#enabled-items') do
      expect(page).to have_content("Status: enabled")
      items1.each do |item|
        expect(page).to have_content(item.name)
      end

      items2.each do |item|
        expect(page).to have_content(item.name)
      end
    end

    within('section#disabled-items') do
      expect(page).to have_content("Status: disabled")
      items2.each do |item|
        expect(page).to have_content(item.name)
      end

      items4.each do |item|
        expect(page).to have_content(item.name)
      end
    end
  end

  it "has a link to a page with a form to create a new item and it works" do
    merchant = Merchant.create!(name: "Snow-Globes and Used Clothing")
    items1 = create_list(:item, 23, merchant_id: merchant.id, status: "enabled")
    items2 = create_list(:item, 17, merchant_id: merchant.id, status: "disabled")
    items3 = create_list(:item, 11, merchant_id: merchant.id, status: "enabled")
    items4 = create_list(:item, 13, merchant_id: merchant.id, status: "disabled")

    visit "/merchants/#{merchant.id}/items"
    expect(page).to have_link("Create New Item")
    click_link "Create New Item"

    expect(current_path).to eq("/merchants/#{merchant.id}/items/new")
    expect(page).to have_selector('form#New_Item')

    fill_in("Name", with: "Tiny toy")
    fill_in('Description', with: 'The teeniest tiniest toy you ever saw')
    fill_in('Unit price', with: 1501)
    click_button "Create Item"

    expect(current_path).to eq("/merchants/#{merchant.id}/items")
    expect(page).to have_content('Tiny toy')
    expect(page).to have_content('The teeniest tiniest toy you ever saw')
    expect(page).to have_content(15.01)
    expect(page).to have_content("Name: Tiny toy Description: The teeniest tiniest toy you ever saw, Price: $15.01, Status: disabled")
    expect(page).to have_content("Item created successfully")

    visit "/merchants/#{merchant.id}/items/new"
    expect(page).to have_content("Create New Item:")
    fill_in("Name", with: "nmame")
    fill_in('Description', with: "")
    fill_in('Unit price', with: 1501)
    click_button "Create Item"

    expect(current_path).to eq("/merchants/#{merchant.id}/items/new")
    expect(page).to have_content("Create New Item:")
    expect(page).to have_content("Item not created successfully")
  end

  it "shows top 5 items that made the most money and shows the total amount made for each item" do
    merchant_1 = Merchant.create!(name: "Walmart")
    item1 = merchant_1.items.create!(name: "popcan", description: "fun", unit_price: 100)
    item2 = merchant_1.items.create!(name: "popper", description: "fun", unit_price: 156)
    item3 = merchant_1.items.create!(name: "zipper", description: "pants", unit_price: 340)
    item4 = merchant_1.items.create!(name: "zoozah", description: "doot", unit_price: 354)
    item5 = merchant_1.items.create!(name: "oiko", description: "zeelk", unit_price: 4)
    item6 = merchant_1.items.create!(name: "onion pillow", description: "kids", unit_price: 1030)
    item7 = merchant_1.items.create!(name: "stash", description: "costume", unit_price: 1070)
    item8 = merchant_1.items.create!(name: "bbq pork powder", description: "toothpaste", unit_price: 1200)
    item9 = merchant_1.items.create!(name: "arrows", description: "survival", unit_price: 600)
    item10 = merchant_1.items.create!(name: "cream of pickles", description: "body care", unit_price: 2100)
    item11 = merchant_1.items.create!(name: "elephant", description: "livestock", unit_price: 2345100)
    item12 = merchant_1.items.create!(name: "car seat cooler", description: "experimental", unit_price: 23100)
    item13 = merchant_1.items.create!(name: "sorry notes", description: "dating", unit_price: 10430)
    item14 = merchant_1.items.create!(name: "crimson tie", description: "costume", unit_price: 10)
    item15 = merchant_1.items.create!(name: "syrup", description: "self help", unit_price: 13040)
    customer1 = Customer.create!(first_name: "John", last_name: "Smith")
    customer2 = Customer.create!(first_name: "Jane", last_name: "Sornes")
    customer3 = Customer.create!(first_name: "Jaques", last_name: "Snipes")
    customer4 = Customer.create!(first_name: "Jay", last_name: "Snape")
    customer5 = Customer.create!(first_name: "Tom", last_name: "Bullocks")
    customer6 = Customer.create!(first_name: "Jimmy", last_name: "Dirt")
    customer7 = Customer.create!(first_name: "Helva", last_name: "Harrock")
    invoice1 = customer1.invoices.create!(status:2)
    invoice2 = customer2.invoices.create!(status: 2)
    invoice3 = customer3.invoices.create!(status: 2)
    invoice4 = customer4.invoices.create!(status: 2)
    invoice5 = customer5.invoices.create!(status: 2)
    invoice6 = customer6.invoices.create!(status: 2)
    invoice7 = customer7.invoices.create!(status: 2)#13567
    invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 6, unit_price: 100, status: 2)
    invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 156, status: 2)
    invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 11, unit_price: 340, status: 2)
    invoice_item4 = invoice2.invoice_items.create!(item_id: item4.id, quantity: 18, unit_price: 354, status: 2)
    invoice_item5 = invoice2.invoice_items.create!(item_id: item5.id, quantity: 4, unit_price: 4, status: 2)
    invoice_item6 = invoice3.invoice_items.create!(item_id: item6.id, quantity: 1, unit_price: 1030, status: 2)
    invoice_item7 = invoice3.invoice_items.create!(item_id: item7.id, quantity: 4, unit_price: 1070, status: 2)
    invoice_item8 = invoice4.invoice_items.create!(item_id: item8.id, quantity: 3, unit_price: 1200000, status: 2)
    invoice_item9 = invoice4.invoice_items.create!(item_id: item9.id, quantity: 5, unit_price: 600, status: 2)
    invoice_item10 = invoice4.invoice_items.create!(item_id: item10.id, quantity: 1, unit_price: 2100, status: 2)
    invoice_item11 = invoice5.invoice_items.create!(item_id: item11.id, quantity: 5, unit_price: 2345100, status: 2)
    invoice_item12 = invoice5.invoice_items.create!(item_id: item12.id, quantity: 7, unit_price: 23100, status: 2)
    invoice_item13 = invoice6.invoice_items.create!(item_id: item13.id, quantity: 3, unit_price: 10430, status: 2)
    invoice_item14 = invoice7.invoice_items.create!(item_id: item14.id, quantity: 7, unit_price: 10, status: 2)
    invoice_item15 = invoice7.invoice_items.create!(item_id: item15.id, quantity: 2, unit_price: 13040, status: 2)
    transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/30", result: 0)
    transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/28", result: 1)
    transaction3 = invoice3.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/15", result: 0)
    transaction4 = invoice4.transactions.create!(credit_card_number: 1238567876567476, credit_card_expiration_date: "04/12", result: 1)
    transaction5 = invoice5.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/25", result: 0)
    transaction6 = invoice6.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/24", result: 0)
    transaction7 = invoice7.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/23", result: 0)

    visit merchant_items_path(merchant_1)

    expect(current_path).to eq("/merchants/#{merchant_1.id}/items")
    expect(page).to have_content("Top 5 Money-Makers:")
    expect(page).to have_content("Product: elephant Earned: $117255.0")
    expect(page).to have_content("Product: car seat cooler Earned: $1617.0")
    expect(page).to have_content("Product: sorry notes Earned: $312.9")
    expect(page).to have_content("Product: syrup Earned: $260.8")
    expect(page).to have_content("Product: stash Earned: $42.8")

    expect("Earned: $117255.0").to appear_before("Earned: $42.8")
  end


  it "has a top items best day for each top item" do
  merchant_1 = Merchant.create!(name: "Walmart")
  item1 = merchant_1.items.create!(name: "popcan", description: "fun", unit_price: 10)
  item2 = merchant_1.items.create!(name: "popper", description: "fun", unit_price: 10)
  item3 = merchant_1.items.create!(name: "zipper", description: "pants", unit_price: 10)

  customer1 = Customer.create!(first_name: "John", last_name: "Smith")
  customer2 = Customer.create!(first_name: "Jane", last_name: "Sornes")
  customer3 = Customer.create!(first_name: "Jaques", last_name: "Snipes")
  customer4 = Customer.create!(first_name: "Jay", last_name: "Snape")
  customer5 = Customer.create!(first_name: "Tom", last_name: "Bullocks")
  customer6 = Customer.create!(first_name: "Jimmy", last_name: "Dirt")
  customer7 = Customer.create!(first_name: "Helva", last_name: "Harrock")
  invoice1 = customer1.invoices.create!(created_at: Time.new(2018, 1, 1), status:2)
  invoice2 = customer2.invoices.create!(created_at: Time.new(2018, 2, 2), status: 2)
  invoice3 = customer3.invoices.create!(created_at: Time.new(2018, 3, 3), status: 2)
  invoice4 = customer4.invoices.create!(created_at: Time.new(2018, 4, 4), status: 2)
  invoice5 = customer5.invoices.create!(created_at: Time.new(2018, 5, 5), status: 2)
  invoice6 = customer6.invoices.create!(created_at: Time.new(2018, 6, 6), status: 2)
  invoice7 = customer7.invoices.create!(created_at: Time.new(2018, 7, 7), status: 2)#13567
  invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 10, status: 2)
  invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 3, status: 2)
  invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 10, status: 2)
  invoice_item4 = invoice2.invoice_items.create!(item_id: item1.id, quantity: 2, unit_price: 10, status: 2)
  invoice_item5 = invoice2.invoice_items.create!(item_id: item2.id, quantity: 1, unit_price: 3, status: 2)
  invoice_item6 = invoice2.invoice_items.create!(item_id: item3.id, quantity: 2, unit_price: 10, status: 2)
  transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/30", result: 0)
  transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/28", result: 1)
  transaction3 = invoice3.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/15", result: 0)
  transaction4 = invoice4.transactions.create!(credit_card_number: 1238567876567476, credit_card_expiration_date: "04/12", result: 1)
  transaction5 = invoice5.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/25", result: 0)
  transaction6 = invoice6.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/24", result: 0)
  transaction7 = invoice7.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/23", result: 0)

  visit merchant_items_path(merchant_1)
  expect(page).to have_content("Top Selling Date for popcan was February 02, 2018")
  expect(page).to have_content("Top Selling Date for popper was January 01, 2018")
  expect("Top Selling Date for popcan was February 02, 2018").to appear_before("Top Selling Date for popper was January 01, 2018")
  end
end
