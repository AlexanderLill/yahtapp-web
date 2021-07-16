namespace :experimentation_mail do
  task :send_mail, [:user_id] => :environment do |t, args|
    send_mail(args[:user_id])
  end

  task all: :environment do
    send_all
  end

  def send_all
    users = User.where(experimentation_email: true)
    users.each do |user|
      ExperimentationMailer.with(user: user).weekly_mail.deliver_now
    end
  end

  def send_mail(user_id)
    user = User.find(user_id)
    ExperimentationMailer.with(user: user).weekly_mail.deliver_now
  end
end
