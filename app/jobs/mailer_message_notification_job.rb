class MailerMessageNotificationJob < ApplicationJob
  queue_as :default

  def perform(message, receiver, sender)
    ApplicationMailer.message_notification_email(message, receiver, sender).deliver_now
  end
end
