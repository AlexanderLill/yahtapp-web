class ExperimentationMailer < ApplicationMailer
  default from: 'hello@yaht.app'


  def weekly_mail
    @user = params[:user]
    mail(to: @user.email, subject: 'Your productivity was up 10% this week.')
  end

end
