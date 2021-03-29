require 'rails_helper'

describe Api::V1::AuthenticationController, type: :request do

  let (:user) { create(:user) }
  version = :v1
  api_path = "/api/#{version}"

  context 'When fetching a user' do
    before do
      login_with_api(user)
      puts response.headers['Authorization']
      @response = response
      get "#{api_path}/users/#{user.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the user' do
      expect(json['data']['id']).to eq(user.id)
      expect(json['data']['username']).to eq(user.username)
      expect(json['data']['email']).to eq(user.email)
    end
  end

  context 'When a user is missing' do
    before do
      login_with_api(user)
      get "#{api_path}/users/blank", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  context 'When the Authorization header is missing' do
    before do
      get "#{api_path}/users/#{user.id}"
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end

end