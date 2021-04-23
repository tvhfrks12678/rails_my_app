require 'rails_helper'

RSpec.describe 'UsersLogins', type: :system do
  scenario 'log in' do
    visit root_path
    # login with invalid information
    invalid_user = build(:user, email: 'invalid@email', password: 'foo')
    log_in_as(invalid_user)
    expect_failed_to_log_in

    # no flash message after move page
    click_link 'Home'
    expect(page).to_not have_css '.alert'

    # login with valid email/invalid password
    valid_user = create(:user)
    valid_email_invalid_password_user = build(:user, email: valid_user.email, password: 'foo')
    log_in_as(valid_email_invalid_password_user)
    expect_failed_to_log_in

    # login with valid information
    log_in_as(valid_user)
    expect_successfully_log_in_as(valid_user)
  end

  def log_in_as(user)
    click_link 'Log in'
    fill_in 'session_email',	with: user.email
    fill_in 'session_password',	with: user.password
    click_button 'ログイン'
  end

  def expect_failed_to_log_in
    expect(current_path).to eq login_path
    expect(page).to have_css '.alert-danger'
  end
end
