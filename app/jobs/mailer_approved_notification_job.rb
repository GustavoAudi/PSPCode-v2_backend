
class MailerApprovedNotificationJob < ApplicationJob
  queue_as :default

  def perform(status, receiver, sender, assigned_project, message)
    ApplicationMailer.approved_notification_email(status, receiver, sender, assigned_project,
                                                  message)
                     .deliver_now
  end
end
