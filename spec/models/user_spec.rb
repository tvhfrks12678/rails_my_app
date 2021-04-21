# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  subject { build(:user) }

  it 'should be valid' do
    is_expected.to be_valid
  end

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

      it do
        should allow_values('user@example.com', 'USER@foo.COM', 'A_US-ER@foo.bar.org', 'first.last@foo.jp',
                            'alice+bob@baz.c').for(:email)
      end

      it do
        should_not allow_values('user@example,com', 'user_at_foo.org', 'user.name@example.', 'foo@bar_baz.com',
                                'foo@bar+baz.com', 'foo@bar..com').for(:email)
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

  describe 'password' do
    context 'validations' do
      it { should have_secure_password }

      it 'should be present(nonblank)' do
        user = build(:user, password: ' ' * 6, password_confirmation: ' ' * 6)
        user.valid?
        expect(user.errors).to be_of_kind(:password, :blank)
      end

      it { should validate_length_of(:password).is_at_least(6) }
    end
  end
end
