json.data do
  json.occurrences @occurrences do |occurrence|
    json.id occurrence.id
    json.scheduled_at occurrence.scheduled_at.nil? ? nil : occurrence.scheduled_at.iso8601(3)
    json.started_at occurrence.started_at.nil? ? nil : occurrence.started_at.iso8601(3)
    json.ended_at occurrence.ended_at.nil? ? nil : occurrence.ended_at.iso8601(3)
    json.skipped_at occurrence.skipped_at.nil? ? nil : occurrence.skipped_at.iso8601(3)

    # Nested habits
    json.habit do
      json.id  occurrence.habit.id
      json.title  occurrence.habit.title
      json.duration  occurrence.habit.duration
      json.is_skippable  occurrence.habit.is_skippable
    end
  end
end
