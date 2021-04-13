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
      occs = json['data']
      expect(occs).to be_a(Array)
      expect(occs).not_to be_empty
      expect(occs.count).to eq(user.occurrences.count)
    end

    it "returns the times of the occurrences in the user's timezone" do
      body = response.body
      occs = json['data']
      strdate = occs[0]['scheduled_at']
      parsed_date = Time.strptime(strdate,"%Y-%m-%dT%H:%M:%S.%L%:z")
      local_date = Time.now.in_time_zone(user.timezone)
      expect(parsed_date.strftime("%Z")).to eq(local_date.strftime("%Z"))
    end

  end

  context 'When marking an occurrence as started' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = habit.occurrences.first!
      # use travel_to to set the date after that habit's occurrence
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          started_at: Date.current.iso8601
        }
      }
    end
    it 'returns 200' do
      expect(response.status).to eq(200)
    end
    it 'marks occurrence as started' do
      body = response.body
      occ = json['data']
      expect(Occurrence.find(@occ.id).started_at.present?).to eq true
      expect(occ['started_at'].present?).to eq true
    end
  end


end