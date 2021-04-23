require 'rails_helper'

RSpec.describe 'UsersLogins', type: :system do
  scenario 'log in' do
    visit root_path
    # login with invalid information
    invalid_user = build(:user, email: 'invalid@email', password: 'foo')
    log_in_as(invalid_user)
    expect_log_in_failure

    # 移動先にフラッシュメッセージが表示されないか
    click_link 'Home'
    expect(page).to_not have_css '.alert'

    # login with valid email/invalid password
    valid_user = create(:user)
    valid_email_invalid_password_user = build(:user, email: valid_user.email, password: 'foo')
    log_in_as(valid_email_invalid_password_user)
    expect_log_in_failure

    # login with valid information
    log_in_as(valid_user)
    expect_log_in_success(valid_user)
  end

  def log_in_as(user)
    click_link 'Log in'
    fill_in 'session_email',	with: user.email
    fill_in 'session_password',	with: user.password
    click_button 'ログイン'
  end

  def expect_log_in_failure
    expect(current_path).to eq login_path
    expect(page).to have_css '.alert-danger'
  end

  def expect_log_in_success(user)
    expect(current_path).to eq user_path(user)
    within 'header > div > nav' do
      expect(page).to_not have_link 'Log in'
      header_link_words = %w[投稿 Profile Setting Log\ out]
      header_link_words.each do |header_link_word|
        expect(page).to have_link header_link_word
      end
    end
  end
end
