require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelperHelper. For example:
#
# describe ApplicationHelperHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  BASE_TITLE = '韻クイズ'

  describe '#full_title(page_title = \'\')' do
    context 'page_titleが空白の時' do
      it '|を含まないTitleをreturnする' do
        expect(full_title).to eq BASE_TITLE
      end
    end

    context 'page_titleがAboutの時' do
      it '|を含むTitleをreturnする' do
        expect(full_title('About')).to eq "About | #{BASE_TITLE}"
      end
    end
  end  
end
