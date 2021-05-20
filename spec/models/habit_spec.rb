require 'rails_helper'

# Occurrence:
# schedule 7 days in advance
# update: - whenever there is a change
#         - at least once daily
#

describe Habit, type: :model do

  context "When scheduling occurrences" do
    it "future occurrences are created according to the schedule" do
      habit = create(:habit)
      schedule = habit.get_schedule(ending: 7.days.from_now.at_end_of_day)
      occurrences = Occurrence.where("scheduled_at >= ?", habit.updated_at).where(:habit => habit).to_a
      expect(occurrences.count).to eq(schedule.count)
      expect(schedule).to match_array(occurrences.map(&:scheduled_at))
    end
    it "future occurrences are deleted when the schedule is changed" do
      # create habit with schedule
      old_schedule = Montrose::Schedule.new
      old_schedule << Montrose.every(:week).on([:tuesday, :friday]).at("12:00")
      habit = create(:habit, schedule: old_schedule)

      # change the schedule
      habit.clear_schedule
      habit.add_recurrence(on: [:tuesday, :friday], at: "12:00")
      habit.save

      # check that occurrences were updated
      new_schedule = habit.get_schedule(ending: 7.days.from_now.at_end_of_day)
      occurrences = Occurrence.where("scheduled_at >= ?", habit.updated_at).where(:habit => habit).to_a
      expect(occurrences.count).to eq(new_schedule.count)
      expect(new_schedule).to match_array(occurrences.map(&:scheduled_at))
    end
  end
  context "When cloning a habit" do
    let(:user) { create(:user) }
    before do
      @goal = create(:goal, is_template: true)
      @habit = create(:habit, goal: @goal, is_template: true)
      @new_habit = @habit.clone(user)
    end
    it "fails if habit is not a template" do
      goal = create(:goal, is_template: true)
      habit = create(:habit, goal: goal, is_template: false)
      expect { habit.clone(user) }.to raise_error
    end
    it "creates a copy of the habit and the habit config with all relevant attributes" do
      expect(@new_habit.title).to eq(@habit.title)
      expect(@new_habit.duration).to eq(@habit.duration)
      expect(@new_habit.goal_id).to eq(@habit.goal_id)
      expect(@new_habit.is_skippable).to eq(@habit.is_skippable)
      expect(@new_habit.recurrence_on).to eq(@habit.recurrence_on)
      expect(@new_habit.recurrence_at).to eq(@habit.recurrence_at)
      expect(@new_habit.current_config_id).not_to eq(@habit.current_config_id)
    end
    it "sets the template_id to the cloned habit" do
      expect(@new_habit.template_id).to eq(@habit.id)
    end
    it "sets is_template of the cloned habit to false" do
      expect(@new_habit.is_template).to be_falsey
    end
    it "sets the correct user on the cloned habit" do
      expect(@new_habit.user).to eq(user)
    end

  end

  context "When scheduling a habit" do
    let(:habit_form) { HabitForm.new }
    it "daily recurrences at a single specific time can be added" do
      at = Time.current.strftime("%H:%M")
      habit = create(:habit, recurrence_at: at, recurrence_on: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'])
      schedule = habit.get_schedule(ending: 1.days.from_now.at_end_of_day)
      expect(schedule.map { |date| date.strftime "%H:%M" }).to all( match(at))
    end
    it "daily recurrences at multiple times can be added" do
      times = [Time.current.strftime("%H:%M"), 1.hours.from_now.strftime("%H:%M")].join(",")
      habit = create(:habit, recurrence_at: times, recurrence_on: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'])
      schedule = habit.get_schedule(ending: 1.days.from_now.at_end_of_day)
      expect(schedule.map { |date| date.strftime "%H:%M" }).to all( match(times[0]).or match(times[1]) )
    end
    it "weekly recurrences at a single specific day and time can be added" do
      at = Time.current.strftime("%H:%M")
      on = [Time.current.strftime("%A").downcase]
      habit = create(:habit, recurrence_at: at, recurrence_on: on)
      schedule = habit.get_schedule(ending: 1.week.from_now.at_end_of_day)
      expect(schedule.map { |date| date.strftime "%H:%M" }).to all( match(at))
      expect(schedule.map { |date| date.strftime("%A").downcase }).to all( eq(on[0]))
    end
    it "weekly recurrences on multiple days at multiple times can be added" do
      times = [Time.current.strftime("%H:%M"), 1.hours.from_now.strftime("%H:%M")].join(",")
      days = [
        Time.current.strftime("%A").downcase,
        1.day.from_now.strftime("%A").downcase,
      ]
      habit = create(:habit, recurrence_at: times, recurrence_on: days)
      schedule = habit.get_schedule(ending: 1.week.from_now.at_end_of_day)
      expect(schedule.map { |date| date.strftime"%H:%M" }).to all( match(times[0]).or match(times[1]) )
      expect(schedule.map { |date| date.strftime("%A").downcase }).to all( eq(days[0]).or eq(days[1]))
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
