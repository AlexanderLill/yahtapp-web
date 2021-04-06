require 'rails_helper'

# Occurrence:
# schedule 7 days in advance
# update: - whenever there is a change
#         - at least once daily
#

describe Habit, type: :model do
  let(:habit) { create(:habit) }
  context "When scheduling a habit" do
    it "daily recurrences at a single specific time can be added" do
      at = Time.current.strftime("%H:%M")
      habit.add_recurrence(type: :day, at: at)
      schedule = habit.get_schedule(ending: 1.days.from_now.at_end_of_day)
      expect(schedule.map { |date| date.strftime "%H:%M" }).to all( match(at))
    end
    it "daily recurrences at multiple times can be added" do
      times = [Time.current.strftime("%H:%M"), 1.hours.from_now.strftime("%H:%M")]
      habit.add_recurrence(type: :day, at: times)
      schedule = habit.get_schedule(ending: 1.days.from_now.at_end_of_day)
      expect(schedule.map { |date| date.strftime "%H:%M" }).to all( match(times[0]).or match(times[1]) )
    end
    it "weekly recurrences at a single specific day and time can be added" do
      at = Time.current.strftime("%H:%M")
      on = Time.current.strftime("%A").downcase.to_sym
      habit.add_recurrence(type: :week, on: on, at: at)
      schedule = habit.get_schedule(ending: 1.week.from_now.at_end_of_day)
      expect(schedule.map { |date| date.strftime "%H:%M" }).to all( match(at))
      expect(schedule.map { |date| date.strftime("%A").downcase.to_sym }).to all( eq(on))
    end
    it "weekly recurrences on multiple days at multiple times can be added" do
      times = [Time.current.strftime("%H:%M"), 1.hours.from_now.strftime("%H:%M")]
      days = [
        Time.current.strftime("%A").downcase.to_sym,
        1.day.from_now.strftime("%A").downcase.to_sym,
      ]
      habit.add_recurrence(type: :week, on: days, at: times)
      schedule = habit.get_schedule(ending: 1.week.from_now.at_end_of_day)
      expect(schedule.map { |date| date.strftime"%H:%M" }).to all( match(times[0]).or match(times[1]) )
      expect(schedule.map { |date| date.strftime("%A").downcase.to_sym }).to all( eq(days[0]).or eq(days[1]))
    end
    it "daily recurrences at a single time can be removed" do

    end
    it "daily recurrences at at multiple times can be removed" do
    end
    it "weekly recurrences at a single specific time can be removed" do
    end
    it "weekly recurrences at multiple times can be removed" do
    end
    it "the schedule can be cleared" do

    end
  end
end
