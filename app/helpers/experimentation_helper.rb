module ExperimentationHelper

  def done_occs_from_habit(habit, start_date, end_date)
    habit.occurrences
                .where('scheduled_at >= ?', start_date)
                .where('scheduled_at <= ?', end_date)
                .where('started_at IS NOT NULL').count
                #.where('ended_at IS NOT NULL')

  end

  def total_occs_from_habit(habit, start_date, end_date)
    habit.occurrences
         .where('scheduled_at >= ?', start_date)
         .where('scheduled_at <= ?', end_date)
         .count
  end

  def percentage_change(habit, current_start_date, current_end_date, previous_start_date, previous_end_date)
    current_done = done_occs_from_habit(habit, current_start_date, current_end_date)
    current_total = total_occs_from_habit(habit, current_start_date, current_end_date)
    current_ratio = current_total.zero? ? 0 : current_done.to_f / current_total.to_f

    previous_done = done_occs_from_habit(habit, previous_start_date, previous_end_date)
    previous_total = total_occs_from_habit(habit, previous_start_date, previous_end_date)
    previous_ratio = previous_total.zero? ? 0 : previous_done.to_f / previous_total.to_f


    return previous_ratio.zero? ? (current_ratio.zero? ? 0 : 100) : (current_ratio / previous_ratio * 100)

  end


  def average_self_report(self_reports)
    avg = self_reports.average(:value)
    if avg.nil?
      "-"
    else
      avg.round(2)
    end
  end

  def average_percentage_change(current_avg, previous_avg)
    if current_avg.is_a? Numeric and !previous_avg.is_a? Numeric
      100
    end
    if !current_avg.is_a? Numeric and previous_avg.is_a? Numeric
      -100
    end
    if !current_avg.is_a? Numeric and !previous_avg.is_a? Numeric
      nil
    end
    (current_avg/previous_avg * 100).round(2)
  end

  def subjective_goal_contribution(habit, start_date, end_date)
    avg = habit.habit_reflections
               .where('created_at >= ?', start_date)
               .where('created_at <= ?', end_date)
               .average(:rating)
    if avg.nil?
      nil
    else
      avg.round(2)
    end
  end

end