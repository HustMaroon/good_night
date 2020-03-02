# frozen_string_literal: true

require 'rails_helper'
def error_message(response)
  json = JSON.parse(response.body)
  json['error_message']
end

# shared examples for clock_ins api
shared_examples_for 'invalid params user_id' do
  context 'without user_id' do
    let(:params) { {} }
    before { execute }
    it 'should return error message' do
      expect(error_message response).to eq('Couldn\'t find User without an ID')
    end

    it_behaves_like '404'
  end

  context 'invalid user_id' do
    let(:invalid_id) { 'random string' }
    let(:params) { { user_id: invalid_id } }
    before { execute }
    it 'should return error message' do
      expect(error_message response).to eq("Couldn't find User with 'id'=#{invalid_id}")
    end
    it_behaves_like '404'
  end

  context 'user not exist' do
    let(:non_existing_user_id) { User.last&.id.to_i + 1 }
    let(:params) { {user_id: non_existing_user_id} }
    before { execute }
    it 'should return error message' do
      expect(error_message response).to eq("Couldn't find User with 'id'=#{non_existing_user_id}")
    end
    it_behaves_like '404'
  end
end

# shared examples for relationship api
shared_examples_for 'invalid params follower_id or followed_id' do
  # invalid follower_id
  context 'without follower_id' do
    let(:params) { { followed_id: followed.id } }
    before { execute }
    it 'should return error message' do
      expect(error_message response).to eq('Couldn\'t find User without an ID')
    end

    it_behaves_like '404'
  end

  context 'invalid follower_id' do
    let(:invalid_id) { 'random string' }
    let(:params) { { follower_id: invalid_id, followed_id: followed.id } }
    before { execute }
    it 'should return error message' do
      expect(error_message response).to eq("Couldn't find User with 'id'=#{invalid_id}")
    end
    it_behaves_like '404'
  end

  context 'user not exist' do
    let(:non_existing_user_id) { User.last&.id.to_i + 1 }
    let(:params) { { follower_id: non_existing_user_id, followed_id: followed.id } }
    before { execute }
    it 'should return error message' do
      expect(error_message response).to eq("Couldn't find User with 'id'=#{non_existing_user_id}")
    end
    it_behaves_like '404'
  end

  # invalid followed_id
  context 'without followed_id' do
    let(:params) { { follower_id: follower.id } }
    before { execute }
    it 'should return error message' do
      expect(error_message response).to eq('Couldn\'t find User without an ID')
    end

    it_behaves_like '404'
  end

  context 'invalid followed_id' do
    let(:invalid_id) { 'random string' }
    let(:params) { { follower_id: invalid_id, followed_id: followed.id } }
    before { execute }
    it 'should return error message' do
      expect(error_message response).to eq("Couldn't find User with 'id'=#{invalid_id}")
    end
    it_behaves_like '404'
  end

  context 'user not exist' do
    let(:non_existing_user_id) { User.last&.id.to_i + 1 }
    let(:params) { { followed_id: non_existing_user_id, follower_id: followed.id } }
    before { execute }
    it 'should return error message' do
      expect(error_message response).to eq("Couldn't find User with 'id'=#{ non_existing_user_id }")
    end
    it_behaves_like '404'
  end
end

codes = [422, 404, 406, 200, 201, 202, 204]
codes.each do |code|
  shared_examples code.to_s do
    specify "return #{code}" do
      expect(response.status).to eq(code)
    end
  end
end