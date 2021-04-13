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

  # TODO: write test that checks permissions (e.g. only own occurrences can be updated)

  context 'When marking an occurrence as started' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = habit.occurrences.first!
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
      occ = json['data']
      expect(Occurrence.find(@occ.id).started_at.present?).to eq true
      expect(occ['started_at'].present?).to eq true
    end
  end

  context 'When marking an already started occurrence as started' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, started_at: Date.current)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          started_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['started_at']).not_to be_empty
    end
  end

  context 'When marking an already ended occurrence as started' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, started_at: Date.current, ended_at: 5.minutes.from_now)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          started_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['started_at']).not_to be_empty
    end
  end

  context 'When marking an already skipped occurrence as started' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, started_at: Date.current, skipped_at: 5.minutes.from_now)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          started_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['started_at']).not_to be_empty
    end
  end

  context 'When marking an already skipped occurrence as started' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, started_at: Date.current, skipped_at: 5.minutes.from_now)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          started_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['started_at']).not_to be_empty
    end
  end

  context 'When marking an occurrence as ended' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, started_at: DateTime.current)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          ended_at: 2.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 200' do
      expect(response.status).to eq(200)
    end
    it 'marks occurrence as ended' do
      body = response.body
      occ = json['data']
      expect(Occurrence.find(@occ.id).ended_at.present?).to eq true
      expect(occ['ended_at'].present?).to eq true
    end
  end

  context 'When marking an occurrence as ended that has not started yet' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          ended_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['ended_at']).not_to be_empty
    end
  end

  context 'When marking an occurrence as ended that has already been marked as ended' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, started_at: Date.current, ended_at: 5.minutes.from_now)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          ended_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['ended_at']).not_to be_empty
    end
  end

  context 'When marking an occurrence as ended that has already been marked as skipped' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, skipped_at: Date.current)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          ended_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['ended_at']).not_to be_empty
    end
  end

  context 'When marking an occurrence as ended with a date earlier than the start date' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, started_at: DateTime.current)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          ended_at: 10.minutes.ago.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['ended_at']).not_to be_empty
    end
  end

  context 'When marking an occurrence as skipped' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user, is_skippable: true) # daily habit which is scheduled at the current time
      @occ = habit.occurrences.first!
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          skipped_at: Date.current.iso8601
        }
      }
    end
    it 'returns 200' do
      expect(response.status).to eq(200)
    end
    it 'marks occurrence as skipped' do
      occ = json['data']
      expect(Occurrence.find(@occ.id).skipped_at.present?).to eq true
      expect(occ['skipped_at'].present?).to eq true
    end
  end

  context 'When marking an occurrence as skipped that has a non skippable habit' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user, is_skippable: false) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          skipped_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['skipped_at']).not_to be_empty
    end
  end

  context 'When marking an occurrence as skipped that has already been marked as started' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user, is_skippable: true) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, started_at: Date.current)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          skipped_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['skipped_at']).not_to be_empty
    end
  end

  context 'When marking an occurrence as skipped that has already been marked as ended' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user, is_skippable: true) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, started_at: Date.current, ended_at: 5.minutes.from_now)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          skipped_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['skipped_at']).not_to be_empty
    end
  end

  context 'When marking an occurrence as skipped that has already been marked as skipped' do
    before do
      login_with_api(user)
      habit = create(:daily_habit, user: user, is_skippable: true) # daily habit which is scheduled at the current time
      @occ = create(:occurrence, habit: habit, skipped_at: Date.current)
      put "#{api_path}/users/#{user.id}/occurrences/#{@occ.id}", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        occurrence: {
          skipped_at: 10.minutes.from_now.iso8601
        }
      }
    end
    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      errors = json['errors']
      expect(errors).not_to be_empty
      expect(errors['skipped_at']).not_to be_empty
    end
  end

end