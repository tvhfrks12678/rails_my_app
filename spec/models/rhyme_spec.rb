require 'rails_helper'

RSpec.describe Rhyme, type: :model do
  it { should validate_presence_of(:content) }
  it { should validate_length_of(:content).is_at_most(30) }
  it { should validate_uniqueness_of(:content) }

  it do
    should allow_values('あい', 'あいうえお').for(:content)
  end

  it do
    should_not allow_values('韻', 'あ伊').for(:content)
  end
end
