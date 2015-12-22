require "spec_helper"

# Probably it would be nice to add a FactoryGirl gem

describe CgtraderLevels::User, type: :model do
  let!(:level_1) { CgtraderLevels::Level.create!(experience: 0, title: 'First level') }
  let!(:level_2) { CgtraderLevels::Level.create!(experience: 10, title: 'Second level') }
  let!(:level_3) { CgtraderLevels::Level.create!(experience: 13, title: 'Third level') }
  let(:empty_user) { CgtraderLevels::User.new }
  let(:user_with_reputation) { CgtraderLevels::User.new(reputation: 10) }

  it { should respond_to(:username) }
  it { should respond_to(:reputation) }
  it { should respond_to(:coins) }
  it { should respond_to(:tax) }
  it { should respond_to(:level_id) }

  describe 'user asscociations' do
    it { should belong_to(:level) }
  end

  describe 'database default values' do
    subject { empty_user }

    it { expect(subject.coins).to eq(0) }
    it { expect(subject.tax).to eq(30) }
  end

  describe 'new user' do
    context "without reputation" do
      subject { empty_user }

      it 'has 0 reputation points' do
        expect(subject.reputation).to eq(0)
      end

      it "has assigned 'First level'" do
        expect(subject.level).to eq(level_1)
      end
    end

    context "with reputation" do
      subject { user_with_reputation }

      it "has assigned 'Second level'" do
        expect(subject.level).to eq(level_2)
      end
    end
  end

  describe 'reduce reputation' do
    before { subject.update_attribute(:reputation, 0) }

    context "changing level" do
      subject { user_with_reputation }

      it "not level down from 'Second level' to 'First level'" do
        # subject.update_attribute(:reputation, 0)
        expect(subject.level).to eq(level_2)
      end
    end

    context "changing privileges" do
      let(:user) { CgtraderLevels::User.create!(tax: 10, reputation: 10) }
      subject { user }

      it 'not reduces tax rate by some quantity' do
        # subject.update_attribute(:reputation, 0)
        expect(subject.tax).to eq(10)
      end
    end

    context "changing bonuses" do
      let(:user) { CgtraderLevels::User.create!(coins: 1, reputation: 10) }
      subject { user }

      it 'not gives some quantity coins to user' do
        # subject.update_attribute(:reputation, 0)
        expect(subject.coins).to eq(1)
      end
    end
  end

  describe 'increase reputation' do
    context "changing level" do
      subject { empty_user }

      it "level ups from 'First level' to 'Second level'" do
        expect {
          subject.update_attribute(:reputation, 10)
        }.to change { subject.level }.from(level_1).to(level_2)
      end

      it "level ups from 'First level' to 'Second level'" do
        expect {
          subject.update_attribute(:reputation, 12)
        }.to change { subject.level }.from(level_1).to(level_2)
      end

      it "level ups from 'First level' to 'Third level'" do
        expect {
          subject.update_attribute(:reputation, 13)
        }.to change { subject.level }.from(level_1).to(level_3)
      end

      it "not level ups from 'First level' to 'Second level'" do
        subject.update_attribute(:reputation, 9)
        expect(subject.level).to eq(level_1)
      end
    end

    context "changing bonuses" do
      let(:initial_count_of_coins) { 1 }
      let(:user) { CgtraderLevels::User.create!(coins: initial_count_of_coins) }
      subject { user }

      it 'gives some quantity coins to user' do
        expect {
          subject.update_attribute(:reputation, 10)
        }.to change { subject.coins }.from(initial_count_of_coins).to(initial_count_of_coins + subject.class::VALUE_OF_REWARD)
      end

      it 'gives double some quantity coins to user' do
        expect {
          subject.update_attribute(:reputation, 13)
        }.to change { subject.coins }.from(initial_count_of_coins).to(initial_count_of_coins + 2 * subject.class::VALUE_OF_REWARD)
      end
    end

    context "changing privileges" do
      let(:initial_tax_rate) { 10 }
      let(:user) { CgtraderLevels::User.create!(tax: initial_tax_rate) }
      subject { user }

      it 'increase tax rate by some quantity' do
        expect {
          subject.update_attribute(:reputation, 10)
        }.to change { subject.tax }.from(initial_tax_rate).to(initial_tax_rate - subject.class::VALUE_OF_PRIVILEGE)
      end

      it 'increase tax rate by double some quantity' do
        expect {
          subject.update_attribute(:reputation, 13)
        }.to change { subject.tax }.from(initial_tax_rate).to(initial_tax_rate - 2 * subject.class::VALUE_OF_PRIVILEGE)
      end
    end
  end
end
