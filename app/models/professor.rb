# == Schema Information
#
# Table name: professors
#
#  id                             :integer          not null, primary key
#  email                          :string           default(""), not null
#  encrypted_password             :string           default(""), not null
#  reset_password_token           :string
#  reset_password_sent_at         :datetime
#  remember_created_at            :datetime
#  sign_in_count                  :integer          default(0), not null
#  current_sign_in_at             :datetime
#  last_sign_in_at                :datetime
#  current_sign_in_ip             :inet
#  last_sign_in_ip                :inet
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  first_name                     :string
#  last_name                      :string
#  additional_notes               :string
#  provider                       :string           default("email"), not null
#  uid                            :string           default(""), not null
#  tokens                         :json
#  last_seen_event_notification   :datetime
#  last_seen_message_notification :datetime
#
# Indexes
#
#  index_professors_on_email                 (email) UNIQUE
#  index_professors_on_reset_password_token  (reset_password_token) UNIQUE
#  index_professors_on_uid_and_provider      (uid,provider) UNIQUE
#

class Professor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  include DeviseTokenAuth::Concerns::User
  include ActAsEntityWithName
  include ActAsEntityWithNotifications

  has_many :sent_messages, class_name: 'Message', as: :sender, dependent: :destroy
  has_many :professor_courses
  has_many :event_notifications, as: :receiver, dependent: :destroy
  has_many :message_notifications, as: :receiver, dependent: :destroy
  has_many :students, class_name: 'User'
  has_many :courses, through: :professor_courses

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: true }
  validates :first_name, :last_name, presence: true
  validates :password, presence: true, on: :create
  validate :email_user_professor_uniqueness

  def approve_project(assigned_project, message_params)
    assigned_project.update!(status: :approved)
    message = assigned_project.messages.create! message_params.merge!(message_type: :approved)
    MailerApprovedNotificationJob.perform_now('approved',
                                                assigned_project.user,
                                                self,
                                                assigned_project,
                                                message)
  end

  def reject_project(assigned_project, message_params)
    assigned_project.update!(status: :need_correction)
    message = assigned_project.messages.create! message_params.merge!(message_type: :rejected)
    MailerRejectedNotificationJob.perform_now('need_correction',
                                                assigned_project.user,
                                                self,
                                                assigned_project,
                                                message)
  end

  private

  # This method will not avoid to have a small window where duplicate can be created.
  # Between check & insert another insert can happen. This situation will not happen
  # since the users are only created by professors and users cannot update their email.
  def email_user_professor_uniqueness
    return errors.add(:email, 'has already been taken') if User.exists?(email: email)
  end
end
