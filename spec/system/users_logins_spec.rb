require 'rails_helper'

RSpec.describe 'UsersLogins', type: :system do
  scenario 'login with invalid information' do
    visit root_path
    invalid_user = build(:user, email: 'invalid@email', password: 'foo')
    log_in_as(invalid_user)
    expect_log_in_failure
    # 移動先にフラッシュメッセージが表示されないかのチェック
    click_link 'Home'
    expect(page).to_not have_css '.alert'
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
end
