require 'rails_helper'

describe HabitsController, type: :request do
  context 'When scheduling a weekly recurrence twice  a day' do
    before do

      # syntax for setting the schedule on a habit instance
      habit.set_schedule(:week, on: [:monday, :tuesday], at: ["09:00", "3:41 PM"])
      habit.set_schedule(:day, at: ["09:00", "3:41 PM"])
      habit.get_schedule(n: 10) # how many events in the future it should generate
      

      rec1 = Montrose.every(:week, on: [:monday, :tuesday], at: "09:00")
      rec2 = Montrose.every(:week, on: [:monday, :tuesday], at: "3:41 PM")
      schedule = Montrose::Schedule.build do |s|
        s << rec1
        s << rec2
      end
      events = schedule.events.take(5).to_a
    end
    it 'returns 200' do
      puts @schedule.events.take(5).to_a
    end
  end
end