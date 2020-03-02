require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:clock_ins).dependent(:destroy) }
  it { should have_many(:active_relationships).dependent(:destroy) }
  it { should have_many(:following) }
  it { should have_many(:passive_relationships).dependent(:destroy) }
  it { should have_many(:followers) }

  describe '#follow' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    it 'user should be able to follow other_user' do
      user.follow(other_user)
      relationship = Relationship.find_by(follower: user, followed: other_user)
      expect(relationship).not_to be_nil
    end
  end

  describe '#unfollow' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    before { user.follow(other_user) }
    it 'user should be able to unfollow other_user' do
      user.unfollow(other_user)
      relationship = Relationship.find_by(follower: user, followed: other_user)
      expect(relationship).to be_nil
    end
  end

  describe '#following?' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    context 'when not following' do
      it 'should return false' do
        expect(user.following?(other_user)).to eq(false)
      end
    end

    context 'when following' do
      before { user.follow(other_user) }
      it 'should return true' do
        expect(user.following?(other_user)).to eq(true)
      end
    end
  end
end
