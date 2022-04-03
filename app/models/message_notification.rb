# frozen_string_literal: true

# == Schema Information
#
# Table name: message_notifications
#
#  id                  :integer          not null, primary key
#  assigned_project_id :integer          not null
#  originator_type     :string           not null
#  originator_id       :integer          not null
#  receiver_type       :string           not null
#  receiver_id         :integer          not null
#  message_id          :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_message_notifications_on_assigned_project_id  (assigned_project_id)
#  index_message_notifications_on_message_id           (message_id)
#

class MessageNotification < Notification
  belongs_to :message

  validates :message, presence: true

  private

  def send_email_notification
    MailerMessageNotificationJob.perform_now(message, receiver, originator)
  end
end
