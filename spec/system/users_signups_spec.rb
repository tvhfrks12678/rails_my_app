require 'rails_helper'

RSpec.describe 'UsersSignups', type: :system do
  scenario 'invalid signup information' do
    visit root_path
    expect do
      all_items_invalid_user = User.new(name: '', email: 'invalid@email', password: 'foo', password_confirmation: 'bar')
      create_user_account(all_items_invalid_user)
      aggregate_failures do
        expect_signup_all_items_errors
      end
    end.to_not change(User, :count)
  end

  def create_user_account(user)
    visit users_new_path
    fill_in 'user_name',	with: user.name
    fill_in 'user_email', with: user.email
    fill_in 'user_password',	with: user.password
    fill_in 'user_password_confirmation',	with: user.password_confirmation
    click_button 'アカウント作成'
  end

  def expect_signup_all_items_errors
    within '#error_explanation' do
      expect(page).to have_selector '.alert-danger', text: 'エラー'
      user_input_items = %w[Name Email Password Password\ confirmation]
      user_input_items.each do |user_input_item|
        expect(page).to have_content user_input_item
      end
    end
  end
end
