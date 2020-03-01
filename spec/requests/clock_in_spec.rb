# frozen_string_literal: true

require 'rails_helper'
describe 'clock_ins', type: :request do
  let!(:user) { create :user }
  # to track user's sleep time
  # required params: user_id
  describe 'POST /api/sleep' do
    let(:execute) { post '/api/sleep', params: params }
    context 'negative tests' do
      include_examples 'invalid params user_id'
    end

    context 'positive test' do
      let(:params) do
        { user_id: user.id }
      end
      before { execute }
      it 'should return correct json' do
        expected_json = ClockIn.last.as_json
        json = JSON.parse(response.body)
        expect(json).to eq(expected_json)
      end
      it_behaves_like '201'
    end
  end

  # to track user's wakeup time
  # required params: user_id
  describe 'POST /api/wake_up' do
    let(:execute) { post '/api/wake_up', params: params }
    context 'negative tests' do
      include_examples 'invalid params user_id'

      context 'corresponding sleep time not found' do
        let(:params) { { user_id: user.id} }
        before { execute }
        it 'should return error message' do
          json = JSON.parse(response.body)
          expect(json['error_message']).to eq('corresponding sleep time not recorded')
        end
        it_behaves_like '404'
      end
    end

    context 'positive test' do
      let(:params) do
        { user_id: user.id }
      end
      let!(:clock_in) do
        create(:clock_in,
               user: user,
               wakeup_time: nil
        )
      end
      before { execute }
      it 'should return corrected json' do
        expected_json = clock_in.reload.as_json
        json = JSON.parse(response.body)
        expect(json).to eq(expected_json)
      end
      it_behaves_like '202'
    end
  end

  # to retrieve user's all fully recorded clock_in
  # required params: user_id
  describe 'GET /api/clocked_in_times' do
    let(:execute) { get '/api/clocked_in_times', params: params }
    let!(:clock_ins) do
      create_list(
          :clock_in,
          10,
          { user: user }
      )
    end
    context 'negative tests' do
      include_examples 'invalid params user_id'
    end
    context 'positive tests' do
      let(:params) do
        { user_id: user.id }
      end
      before { execute }
      it 'should return correct json' do
        expected_json = clock_ins.as_json
        json = JSON.parse(response.body)
        expect(json).to eq(expected_json)
      end
      it_behaves_like '200'
    end
  end

  # to retrieve all following users' sleep time data in last 7 days, ordered descendingly by total sleep time
  # required params: user_id
  describe 'GET /api/friends_sleep_time' do
    let(:execute) { get '/api/friends_sleep_time', params: params }
    let(:friends) { create_list(:user, 10) }
    before do
      friends.each do |friend|
        Relationship.create(follower: user, followed: friend)
        create_list(
            :clock_in,
            10,
            { user: friend,
              clocked_in_time: rand(1..10.0).round(2),
              created_at: rand((Time.now - 10.days)..Time.now)
            }
        )
      end
    end
    context 'negative tests' do
      include_examples 'invalid params user_id'
    end
    context 'positive tests' do
      let(:params) do
        { user_id: user.id }
      end
      before { execute }
      it 'should return correct json' do
        expected_json = gen_friend_sleep_time_json user.following
        json = JSON.parse(response.body)
        expect(json).to eq(expected_json)
      end
      it_behaves_like '200'
    end
  end
end

def gen_friend_sleep_time_json(users)
  users.sort_by { |u| u.recent_clock_ins.sum(:clocked_in_time) }.reverse # sort by desc
  users.as_json(only: [:id, :name], include: :recent_clock_ins)
end