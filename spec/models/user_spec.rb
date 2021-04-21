# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'name' do
    context 'validation' do
      it { is_expected.to validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_most(50) }
    end
  end

  describe 'email' do
    context 'validation' do
      it { is_expected.to validate_presence_of(:email) }
      it { should validate_length_of(:email).is_at_most(255) }
    end
  end

  describe 'profile' do
    context 'validation' do
      it { should validate_length_of(:profile).is_at_most(255) }
    end
  end
end
