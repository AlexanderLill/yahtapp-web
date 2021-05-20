module OccurrencesHelper
  # TODO: theres a bug here somewhere
  def calculate_streak(occurrences)
    return 0 if occurrences.nil?
    occurrences = occurrences.sort_by { |occ| DateTime.current.to_i - occ.scheduled_at.to_i }
    streak = 0
    occurrences.each_with_index do |occ,index|
      if occ.done?
        if streak > 0 or index == 0
          streak = streak + 1
        end
      end
    end
    streak
  end
end