class MailerSubmittedNotificationJob < ApplicationJob
  queue_as :default

  def perform(status, receiver, sender, assigned_project, project_delivery)
    ApplicationMailer.submitted_notification_email(status, receiver, sender, assigned_project, project_delivery)
                     .deliver_now
  end
end
