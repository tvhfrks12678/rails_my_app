require 'rails_helper'

RSpec.describe 'UsersSignups', type: :system do
  let(:valid_user) { build(:user) }
  let(:all_items_invalid_user) do
    build(:user, name: '', email: 'invalid@email', password: 'foo', password_confirmation: 'bar')
  end

  scenario 'User perform sign-up' do
    # invalid signup informatio
    visit root_path
    expect do
      create_user_account(all_items_invalid_user)
      aggregate_failures do
        expect_signup_all_items_errors
      end
    end.to_not change(User, :count)

    # valid signup information
    expect do
      create_user_account(valid_user)
      aggregate_failures do
        expect_signup_success
      end
    end.to change(User, :count).by(1)
  end

  def create_user_account(user)
    visit signup_path
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
    user = User.last
    expect(current_path).to eq user_path(user)
    expect(page).to have_css '.alert-success'
    expect_successfully_log_in_as(user)
  end
end
