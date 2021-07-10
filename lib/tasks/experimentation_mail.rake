namespace :experimentation_mail do
  task :send_mail, [:user_id] => :environment do |t, args|
    send_mail(args[:user_id])
  end


  def send_mail(user_id)
    user = User.find(user_id)
    ExperimentationMailer.with(user: user).weekly_mail.deliver_now
  end
end
