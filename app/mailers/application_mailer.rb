class ApplicationMailer < ActionMailer::Base
  default from: ENV['FROM_EMAIL_ADDRESS']
  layout 'mailer'

  def message_notification_email(message, receiver, sender)
    @receiver = receiver.decorate
    @sender = sender.decorate
    @message = message
    @assigned_project = message.assigned_project.decorate
    mail(to: receiver.email, subject: "PSP: New Message from #{@sender.full_name}")
  end

  def event_notification_email(status, receiver, sender, assigned_project)
    @status = status
    @sender = sender.decorate
    @assigned_project = assigned_project.decorate
    mail(to: receiver.email, subject: "PSP: The status of your project has changed")
  end

  def assigned_notification_email(status, receiver, sender, assigned_project)
    @status = status
    @sender = sender.decorate
    @assigned_project = assigned_project.decorate
    mail(to: receiver.email, subject: "PSP: New Project assigned")
  end

  def submitted_notification_email(status, receiver, sender, assigned_project, project_delivery)
    @status = status
    @sender = sender.decorate
    @assigned_project = assigned_project.decorate
    @project_delivery = project_delivery
    mail(to: receiver.email, subject: "PSP: New Project submitted")
  end

  def approved_notification_email(status, receiver, sender, assigned_project, message)
    @status = status
    @sender = sender.decorate
    @assigned_project = assigned_project.decorate
    @message = message
    mail(to: receiver.email, subject: "PSP: Project approval")
  end

  def rejected_notification_email(status, receiver, sender, assigned_project, message)
    @status = status
    @sender = sender.decorate
    @assigned_project = assigned_project.decorate
    @message = message
    mail(to: receiver.email, subject: "PSP: Project rejected")
  end

  def use_sendgrid_service?
    ActiveModel::Type::Boolean.new.cast(ENV['USE_SENDGRID_SERVICE'])
  end

  def welcome_email(user, generated_password)
    if Rails.env.development?
      p "User: " + user.decorate.full_name + " | Password: " + generated_password.to_s # Print local password
    end
    if use_sendgrid_service?
      @user = user.decorate
      @generated_password = generated_password
      mail(to: user.email, subject: "Welcome #{@user.full_name} to PSP course.")
    end
  end
end
