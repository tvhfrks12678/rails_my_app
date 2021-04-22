require 'rails_helper'

RSpec.describe 'UsersSignups', type: :system do
  scenario 'User perform sign-up' do
    # invalid signup informatio
    visit root_path
    expect do
      all_items_invalid_user = User.new(name: '', email: 'invalid@email', password: 'foo', password_confirmation: 'bar')
      create_user_account(all_items_invalid_user)
      aggregate_failures do
        expect_signup_all_items_errors
      end
    end.to_not change(User, :count)

    # valid signup information
    expect do
      valid_user = User.new(name: 'tarou', email: 'tarou@example.com', password: 'foobar',
                            password_confirmation: 'foobar')
      create_user_account(valid_user)
      aggregate_failures do
        expect_signup_success
      end
    end.to change(User, :count).by(1)
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
    expect(current_path).to eq users_path
    within '#error_explanation' do
      expect(page).to have_selector '.alert-danger', text: 'エラー'
      user_input_items = %w[Name Email Password Password\ confirmation]
      user_input_items.each do |user_input_item|
        expect(page).to have_content user_input_item
      end
    end
  end

  def expect_signup_success
    expect(current_path).to eq user_path(User.last)
    expect(page).to have_css '.alert-success'
  end
end
