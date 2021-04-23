require 'rails_helper'

RSpec.describe 'UsersLogins', type: :system do
  scenario 'login followed by logout' do
    # login with valid email/invalid password
    valid_user = create(:user)
    valid_email_invalid_password_user = build(:user, email: valid_user.email, password: 'foo')
    log_in_as(valid_email_invalid_password_user)
    expect_failed_to_log_in

    # no flash message after move page
    click_link 'Home'
    expect(page).to_not have_css '.alert'

    # login with valid information
    log_in_as(valid_user)
    expect_successfully_log_in_as(valid_user)

    # logout
    click_link 'Log out'
    expect_log_out
  end

  def log_in_as(user)
    visit root_path
    click_link 'Log in'
    fill_in 'session_email',	with: user.email
    fill_in 'session_password',	with: user.password
    click_button 'ログイン'
  end

  def expect_failed_to_log_in
    expect(current_path).to eq login_path
    expect(page).to have_css '.alert-danger'
  end

  def expect_log_out
    expect(current_path).to eq root_path
    within 'header > div > nav' do
      expect(page).to have_link 'Log in'
      header_link_words = %w[投稿 Profile Setting Log\ out]
      header_link_words.each do |header_link_word|
        expect(page).to_not have_link header_link_word
      end
    end
  end
end
