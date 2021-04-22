require 'rails_helper'

RSpec.describe 'UsersSignups', type: :system do
  scenario 'invalid signup information' do
    visit root_path
    expect do
      visit users_new_path
      fill_in 'user_name',	with: ''
      fill_in 'user_email', with: 'invalid@mail'
      fill_in 'user_password',	with: 'foo'
      fill_in 'user_password_confirmation',	with: 'bar'
      click_button 'アカウント作成'
      aggregate_failures do
        expect(current_path).to eq users_path
        expect(page).to have_selector '.alert-danger', text: 'エラー'
        expect(page).to have_selector '#error_explanation', text: 'Email'
        expect(page).to have_selector '#error_explanation', text: 'Email'
        expect(page).to have_selector '#error_explanation', text: 'Password'
        expect(page).to have_selector '#error_explanation', text: 'Password confirmation'
      end
    end.to_not change(User, :count)
  end
end
