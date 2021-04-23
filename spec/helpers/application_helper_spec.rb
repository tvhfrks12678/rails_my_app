# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title(page_title = \'\')' do
    let(:base_title) { '韻クイズ' }
    context 'when page_title is blank' do
      it 'should not include |' do
        expect(full_title).to eq base_title
      end
    end

    context 'when page_title is About' do
      it 'should include |' do
        expect(full_title('About')).to eq "About | #{base_title}"
      end
    end
  end
end
