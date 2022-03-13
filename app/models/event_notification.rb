# == Schema Information #
# Table name: event_notifications
#
#  id                  :integer          not null, primary key
#  assigned_project_id :integer          not null
#  originator_type     :string           not null
#  originator_id       :integer          not null
#  receiver_type       :string           not null
#  receiver_id         :integer          not null
#  status              :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  project_delivery_id :integer
#
# Indexes
#
#  index_event_notifications_on_assigned_project_id  (assigned_project_id)
#  index_event_notifications_on_project_delivery_id  (project_delivery_id)
#

class EventNotification < Notification
  belongs_to :project_delivery
  validates :status, presence: true

  def send_email_notification
    case status
    when 'assigned'
      MailerAssignedNotificationJob.perform_now(status, receiver, originator, assigned_project)
    when 'being_corrected'
      MailerSubmittedNotificationJob.perform_now(status, receiver, originator, assigned_project, project_delivery)
    end
  end
end
