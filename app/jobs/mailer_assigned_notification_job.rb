
class MailerAssignedNotificationJob < ApplicationJob
  queue_as :default

  def perform(status, receiver, sender, assigned_project)
    ApplicationMailer.assigned_notification_email(status, receiver, sender, assigned_project)
                     .deliver_now
  end
end
