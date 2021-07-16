class ExperimentationMailer < ApplicationMailer
  default from: 'admin@yaht.app'
  
  def weekly_mail
    @user = params[:user]

    @start_datetime = DateTime.now.beginning_of_week
    @report_url = experimentation_url(start: @start_datetime.strftime("%Y-%m-%d"))

    @current_period_start = @start_datetime.beginning_of_day
    @current_period_end = @current_period_start.end_of_day + 6.days

    @last_period_start = @start_datetime.beginning_of_day - 7.days
    @last_period_end = @current_period_start.end_of_day - 1.days

    max_title = ""
    max_average = 0
    max_change = 0

    @user.experience_sample_configs.each do |self_report|
      current_average = self_report.samplings.where('scheduled_at >= ?', @current_period_start).where('scheduled_at <= ?', @current_period_end).average(:value)
      previous_average = self_report.samplings.where('scheduled_at >= ?', @last_period_start).where('scheduled_at <= ?', @last_period_end).average(:value)

      if !current_average.nil? and !previous_average.nil?
        # there is data for both current week and last wek
        change = (((current_average-previous_average)/previous_average) * 100).round(2)
        if change.abs > max_change.abs
          max_change = change
          max_title = self_report.title
        end

      elsif !current_average.nil? and previous_average.nil?
        # there is only data for current week
        if current_average > max_average
          max_average = current_average
          max_title = self_report.title
        end
      else
        # both are nil -> skip
      end
    end

    if max_change != 0
      @subject = "Your #{max_title} was #{ max_change > 0 ? "up" : "down"} #{max_change.round(2)}% this week."
    elsif max_average != 0
      @subject = "Your average #{max_title} was #{ max_average.round(2)} this week."
    else
      @subject = "Your weekly report is ready."
    end

    mail(to: @user.email, subject: @subject)
  end

end
