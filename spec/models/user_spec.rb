# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  subject { FactoryBot.build(:user) }

  describe 'name' do
    context 'validations' do
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_most(50) }
    end
  end

  describe 'email' do
    context 'validations' do
      it { should validate_presence_of(:email) }
      it { should validate_length_of(:email).is_at_most(255) }
      it { should validate_uniqueness_of(:email) }

      it 'shoud accept valid addresses' do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          user.email = valid_address
          user.valid?
          expect(user).to be_valid
        end
      end

      it 'should reject invalid adresses' do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com
                               foo@bar..com]
        invalid_addresses.each do |invalid_address|
          user.email = invalid_address
          user.valid?
          expect(user.errors).to be_of_kind(:email, :invalid)
        end
      end
    end

    context 'when lowercase and uppercase letters are mixed' do
      it 'should be saved as lower-case' do
        mixed_case_email = 'Foo@ExAMPle.CoM'
        user.email = mixed_case_email
        user.save
        expect(user.reload.email).to eq mixed_case_email.downcase
      end
    end
  end

  describe 'profile' do
    context 'validations' do
      it { should validate_length_of(:profile).is_at_most(255) }
    end
  end
end
