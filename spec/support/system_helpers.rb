module SystemHelpers
  def expect_successfully_log_in_as(user)
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
