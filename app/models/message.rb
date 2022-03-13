# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  text                :string
#  sender_id           :integer          not null
#  sender_type         :string           not null
#  assigned_project_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  file                :string
#  message_type        :integer          default("default")
#
# Indexes
#
#  index_messages_on_assigned_project_id  (assigned_project_id)
#

#
#  index_messages_on_assigned_project_id  (assigned_project_id)
#

class Message < ApplicationRecord
  belongs_to :assigned_project
  belongs_to :sender, polymorphic: true

  validates :sender_id, :sender_type, :assigned_project, presence: true

  mount_uploader :file, FileUploader

  enum message_type: { default: 0, poke: 1, rejected: 2, approved: 3 }

  after_create :create_notification

  private

  def create_notification
    return if file.url.present?
    user = assigned_project.user
    receiver = sender == user ? user.professor : user
    MessageNotification.create! assigned_project: assigned_project, originator: sender, receiver: receiver, message: self
  end
end
