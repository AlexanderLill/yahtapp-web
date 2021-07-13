module ExperimentationHelper

  def done_occs_from_habit(habit, start_date, end_date)
    habit.occurrences
                .where('scheduled_at >= ?', start_date)
                .where('scheduled_at <= ?', end_date)
                .where('started_at IS NOT NULL')
                .where('ended_at IS NOT NULL')
                .count
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


end