require 'rails_helper'

describe Api::V1::OccurrencesController, type: :request do

  let (:user) { create(:user, password: "testtest") }
  version = :v1
  api_path = "/api/#{version}"

  context 'When fetching occurrences for a user' do
    before do
      login_with_api(user)
      habit = create(:habit, user: user)
      get "#{api_path}/users/#{user.id}/occurrences", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the occurrences' do
      body = response.body
      occs = json['data']['occurrences']
      expect(occs).not_to be_empty
      expect(occs.count).to eq(user.occurrences.count)
    end
  end

end