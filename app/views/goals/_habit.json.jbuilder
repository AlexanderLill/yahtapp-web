json.extract! habit, :id, :title, :goal_id, :user_id, :reccurence, :duration, :is_template, :is_skippable, :type, :created_at, :updated_at
json.url habit_url(habit, format: :json)
