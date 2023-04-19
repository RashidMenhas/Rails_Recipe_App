require 'rails_helper'

RSpec.describe 'Foods page', type: :system do
  describe 'Foods /index' do
    before(:each) do
      @user = User.create!(name: 'name', email: 'email@gmail.com', password: 'password')
      @food = Food.create!(name: 'food', measurement_unit: 'kg', quantity: 5, price: 10, user_id: @user.id)
      @user.skip_confirmation!
      @user.save!
      visit new_user_session_path
      fill_in 'user_email', with: 'email@gmail.com'
      fill_in 'user_password', with: 'password'
      click_button 'Log in'
      sleep(2)
      visit foods_path
    end

    it 'displays the name of food' do
      expect(page).to have_content(@food.name)
    end

    it 'displays the measurement unit of food' do
      expect(page).to have_content(@food.measurement_unit)
    end

    it 'displays the price of food' do
      expect(page).to have_content(@food.measurement_unit)
    end

    it 'displays a button with text New food' do
      expect(page).to have_content('New food')
    end

    it 'button redirects to a page to add new food' do
      click_link 'New food'
      expect(page).to have_current_path new_food_path
    end
  end
end
