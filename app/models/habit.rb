class Habit < ApplicationRecord
  belongs_to :goal
  belongs_to :user
  serialize :schedule, Montrose::Schedule

  # Schedule consists of multiple recurrences
  # add_recurrence
  def add_recurrence(type:, on: on = nil, at: at = nil)
    unless [:week, :day].include? type
      raise "Type must be either :week or :day"
    end
    if type == :week and (on.nil? or (on.is_a?(Array) and on.empty?))
      raise "Weekdays must be specified when selecting the :week type"
    end
    if at.nil?
      raise "Time must be specified in parameter 'at'"
    else
      at = Array(at)
      at.each do |a|
        schedule.add Montrose.every(type, on: on, at: a).starts(created_at)
      end
      schedule
    end
  end

  def clear_schedule
    schedule = Montrose::Schedule.initialize
  end

  # remove_recurrence
  def remove_recurrence(type:, on: nil, at: nil)
    recurrences = schedule.rules
    schedule = Montrose::Schedule.initialize
    # add all recurrences but the one specified in the function args
  end

  # returns timestamps based on the schedule
  def get_schedule(n: nil, starting: nil, ending: nil)
    schedule = self.schedule
    events = schedule.events
    if starting.nil? and ending.nil? and n.nil?
      raise "At least one parameter must be provided otherwise the schedule will result in an endless loop."
    end
    if starting.nil? and ending.nil?
      events = schedule.events
    end

    if starting.nil?
      starting = Time.now
    end

    unless ending.nil?
      events = []
      schedule.events.each do |date|
        break if date > ending
        if date >= starting
          events << date
        end
      end
    end
    if n.nil?
      events.to_a
    else
      events.take(n).to_a
    end
  end


end
