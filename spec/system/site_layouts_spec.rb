# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SiteLayouts', type: :system do
  include ApplicationHelper

  scenario 'layout links' do
    visit root_path
    # Header
    click_link 'Home'
    expect(current_path).to eq root_path
    expect(page.title).to eq full_title
    click_link '韻とは？'
    expect(current_path).to eq rhyme_path
    expect(page.title).to eq full_title('韻とは？')
    click_link 'Help'
    expect(current_path).to eq help_path
    expect(page.title).to eq full_title('Help')
    click_link 'Log in'
    expect(current_path).to eq login_path
    expect(page.title).to eq full_title('Log in')
    # Footer
    click_link 'Contact'
    expect(current_path).to eq contact_path
    expect(page.title).to eq full_title('Contact')
  end
end
