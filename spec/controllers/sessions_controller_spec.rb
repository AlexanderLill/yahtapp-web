require 'rails_helper'

describe Api::V1::SessionsController, type: :request do

  let (:user) { create(:user, password: "testtest") }
  version = :v1
  api_path = "/api/#{version}"

  context 'When fetching a user' do
    before do
      login_with_api(user)
      puts response.headers['Authorization']
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
  context 'When logging in' do
    before do
      post "#{api_path}/auth", params: {
        user: {
          login: user.username,
          password: "testtest"
        }
      }
    end
    it 'returns 200' do
      expect(response.status).to eq(200)
    end
    it 'returns the token in the header' do
      expect(response.headers).to include('Authorization')
    end
    it 'returns the token in the body' do
      expect(json['data']['token']).not_to be_nil
    end
    it 'returns the user data in the body' do
      expect(json['data']['id']).to eq(user.id)
      expect(json['data']['username']).to eq(user.username)
      expect(json['data']['email']).to eq(user.email)
    end
  end
  context 'When logging out' do
    before do
      login_with_api(user)
      @token = response.headers['Authorization']
      delete "#{api_path}/auth", headers: {
        'Authorization': @token
      }
    end

    it 'returns 204' do
      expect(response.status).to eq(204)
    end

    it 'prevents token from being used again' do
      get "#{api_path}/users/#{user.id}", headers: {
        'Authorization': @token
      }
      expect(response.status).to eq(401)
    end
  end

end