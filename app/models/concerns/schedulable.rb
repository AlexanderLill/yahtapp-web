##
# Adds the *scheduling* functionality to any model
# the field that stores the schedule in the db can be set using +include_schedule(field_name)+
# the attribute +recurrence_on+ can be used to specify the days
# the attribute +recurrence_at+ can be used to specify the times
module Schedulable
  extend ActiveSupport::Concern

  # this ActiveRecord included hook allows the following attributes / methods
  # to be treated the same as if they were implemented on the model this concern
  # will be applied to
  included do
    class_attribute :schedulable_attribute

    before_save :add_recurrence_from_params

    attribute :recurrence_at, :string
    attribute :recurrence_on, :string, array: true

    validate :recurrence_on, :validate_recurrence_on
    validate :recurrence_at, :validate_recurrence_at
    validates :recurrence_on, presence:true

    def validate_recurrence_at
      if recurrence_at
        if recurrence_at.empty?
          errors.add(:recurrence_at, "specify at least one time")
          return
        end
        times = transform_string_to_times(recurrence_at)
        if times.empty?
          errors.add(:recurrence_at, "specify at least one time")
        end
        times.each do |time|
          if time.empty?
            errors.add(:recurrence_at, "time cannot be empty")
          end
        end
      end
    end

    def validate_recurrence_on
      unless recurrence_on.nil?
        if recurrence_on.is_a?(Array)
          recurrence_on.each do |on|
            unless %w[monday tuesday wednesday thursday friday saturday sunday].include? on
              errors.add(:recurrence_on, "must be a valid weekday. '#{on}' is not allowed.")
            end
          end
        else
          errors.add(:recurrence_on, "must be a specified as an array.")
        end
      end
    end

    # parses the underlying schedule and returns only the "on" (day specification) attribute
    def recurrence_on
      unless @recurrence_on.nil?
        return @recurrence_on
      end
      schedule = self.read_attribute(self.class.schedulable_attribute)
      if schedule.nil?
        return []
      end
      schedule.rules.first.to_h[:on]
    end
  end

  # parses the underlying schedule and returns only the "at" (time specification)
  def recurrence_at
    unless @recurrence_at.nil?
      return @recurrence_at
    end
    schedule = self.read_attribute(self.class.schedulable_attribute)
    if schedule.nil?
      return nil
    end
    # montrose stores the "at" times in an array with
    # time[0] = hour
    # time[1] = mins
    # time[2] = secs
    schedule.rules.first.to_h[:at].map{|time| [time[0].to_s.rjust(2,"0"),time[1].to_s.rjust(2,"0")].join(":")}.join(", ")
  end

  def recurrence_on=(value)
    @recurrence_on=value
  end

  def recurrence_at=(value)
    @recurrence_at=value
  end

  def clear_schedule
    self.write_attribute(self.class.schedulable_attribute, Montrose::Schedule.new)
  end

  def remove_recurrence(type:, on: nil, at: nil)
    recurrences = schedule.rules
    schedule = Montrose::Schedule.new
    # add all recurrences but the one specified in the function args
  end

  # Schedule consists of multiple recurrences
  # add_recurrence
  def add_recurrence(type: :week, on: on = nil, at: at = nil)
    type = type.to_sym
    unless [:week, :day].include? type
      raise "Type must be either :week or :day"
    end
    if type == :week and (on.nil? or (on.is_a?(Array) and on.empty?))
      raise "Weekdays must be specified when selecting the :week type"
    end
    schedule = self.read_attribute(self.class.schedulable_attribute)
    if self.schedule.nil?
      schedule = Montrose::Schedule.new
    end
    if at.nil?
      raise "Time must be specified in parameter 'at'"
    else
      schedule.add Montrose.every(type, on: on, at: at).starts(created_at)
      self.write_attribute(self.class.schedulable_attribute, schedule)
    end
  end

  # returns timestamps based on the schedule
  def get_schedule(n: nil, starting: nil, ending: nil)
    schedule = self.read_attribute(self.class.schedulable_attribute)
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

  # transforms a string of times to an array
  # e.g. "12:00, 09:00" will be turned into ["12:00","09:00"]
  def transform_string_to_times(string)
    string.scan(/([0-9]+:[0-9]+|[0-9]+\.[0-9]+|[0-9]{4})/i).flatten
  end

  # transforms the two attributes recurrence_on and recurrence_at into
  # an underlying montrose schedule that will be saved to the DB
  def add_recurrence_from_params
    on = recurrence_on.map(&:to_sym)
    at = transform_string_to_times(recurrence_at)
    clear_schedule
    add_recurrence(type: :week, on: on, at: at)
  end


  module ClassMethods
    def include_schedule(value)
      self.schedulable_attribute = value
      serialize value, Montrose::Schedule
    end
  end
end