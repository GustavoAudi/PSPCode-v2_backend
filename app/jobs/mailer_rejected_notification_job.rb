# frozen_string_literal: true

class MailerRejectedNotificationJob < ApplicationJob
  queue_as :default

  def perform(status, receiver, sender, assigned_project, message)
    ApplicationMailer.rejected_notification_email(status, receiver, sender, assigned_project,
                                                  message)
                     .deliver_now
  end
end
