# frozen_string_literal: true

require 'rails_helper'
describe 'relationship', type: :request do
  let!(:follower) { create :user }
  let!(:followed) { create :user }

  # to follow an user
  # required params: follower_id, followed_id
  describe 'POST /api/v1/follow' do
    let(:execute) { post '/api/v1/follow', params: params }
    context 'negative tests' do
      include_examples 'invalid params follower_id or followed_id'
      context 'the relationship already exists' do
        let(:params) { { follower_id: follower.id, followed_id: followed.id } }
        before do
          follower.follow(followed)
          execute
        end
        it 'should return error message' do
          json = JSON.parse(response.body)
          expect(json['error_message']).to eq('relationship already exists')
        end
        it_behaves_like '422'
      end
    end

    context 'positive tests' do
      let(:params) { { follower_id: follower.id, followed_id: followed.id } }
      before { execute }
      it 'the relationship should be created' do
        relationship = Relationship.find_by(follower: follower, followed: followed)
        expect(relationship).not_to be_nil
      end
      it_behaves_like '204'
    end
  end

  # to unfollow an user
  # required params: follower_id, followed_id
  describe 'POST /api/v1/unfollow' do
    let(:execute) { post '/api/v1/unfollow', params: params }
    context 'negative tests' do
      include_examples 'invalid params follower_id or followed_id'
      context 'the relationship not found' do
        let(:params) { { follower_id: follower.id, followed_id: followed.id } }
        before { execute }
        it 'should return error message' do
          json = JSON.parse(response.body)
          expect(json['error_message']).to eq('relationship not found')
        end
        it_behaves_like '422'
      end
    end

    context 'positive tests' do
      let(:params) { { follower_id: follower.id, followed_id: followed.id } }
      before do
        follower.follow(followed)
        execute
      end
      it 'the relationship should be removed' do
        relationship = Relationship.find_by(follower: follower, followed: followed)
        expect(relationship).to be_nil
      end
      it_behaves_like '204'
    end
  end
end