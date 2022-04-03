# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  email                          :string
#  encrypted_password             :string           default(""), not null
#  reset_password_token           :string
#  reset_password_sent_at         :datetime
#  remember_created_at            :datetime
#  sign_in_count                  :integer          default(0), not null
#  current_sign_in_at             :datetime
#  last_sign_in_at                :datetime
#  current_sign_in_ip             :inet
#  last_sign_in_ip                :inet
#  first_name                     :string           default("")
#  last_name                      :string           default("")
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  provider                       :string           default("email"), not null
#  uid                            :string           default(""), not null
#  tokens                         :json
#  approved_subjects              :text             default([]), is an Array
#  programming_language           :string
#  have_a_job                     :boolean
#  job_role                       :string
#  academic_experience            :string
#  programming_experience         :string
#  collegue_career_progress       :string
#  course_id                      :integer          not null
#  professor_id                   :integer
#  current_assigned_project_id    :integer
#  last_seen_event_notification   :datetime
#  last_seen_message_notification :datetime
#
# Indexes
#
#  index_users_on_course_id                    (course_id)
#  index_users_on_current_assigned_project_id  (current_assigned_project_id)
#  index_users_on_email                        (email) UNIQUE
#  index_users_on_professor_id                 (professor_id)
#  index_users_on_reset_password_token         (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider             (uid,provider) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  include DeviseTokenAuth::Concerns::User
  include ActAsEntityWithName
  include ActAsEntityWithNotifications

  has_many :sent_messages, class_name: 'Message', as: :sender, dependent: :destroy
  has_many :event_notifications, as: :receiver, dependent: :destroy
  has_many :message_notifications, as: :receiver, dependent: :destroy
  has_many :assigned_projects
  belongs_to :course
  belongs_to :professor
  belongs_to :current_assigned_project, class_name: 'AssignedProject'

  validates :uid, uniqueness: { scope: :provider }
  validates :email, presence: true, uniqueness: { case_sensitive: true }
  validates :password, length: { minimum: 8 }, allow_blank: true
  validates :course,
            :first_name,
            :last_name,
            :professor, presence: true
  validate :email_user_professor_uniqueness
  validate :professor_of_same_course

  before_validation :init_uid
  before_create :set_password
  after_create :send_welcome_email

  attr_accessor :generated_password

  def self.from_social_provider(provider, user_params)
    where(provider:, uid: user_params['id']).first_or_create do |user|
      user.password = Devise.friendly_token[0, 20]
      user.assign_attributes user_params.except('id')
    end
  end

  def first_approved_assigned_project
    assigned_project = assigned_projects.first
    return unless assigned_project.approved?

    assigned_project
  end

  def start_working(assigned_project_id)
    assigned_projects.find(assigned_project_id).update!(status: :working)
  end

  def submit_project(assigned_project_id)
    assigned_projects.find(assigned_project_id).update!(status: :being_corrected)
    # TODO, Decide what else is needed besides updating the status
  end

  def start_redeliver(assigned_project_id)
    assigned_projects.find(assigned_project_id).generate_redeliver
  end

  private

  def professor_of_same_course
    return if professor.blank? || course.blank? || professor.courses.include?(course)

    errors.add(:professor, 'Must belong to the same course')
  end

  def set_password
    generated_password = Devise.friendly_token
    self.generated_password = generated_password
    self.password = generated_password
  end

  def send_welcome_email
    MailerWelcomeJob.perform_now(self, generated_password)
  end

  # This method will not avoid to have a small window where duplicate can be created.
  # Between check & insert another insert can happen. This situation will not happen
  # since the users are only created by professors and users cannot update their email.
  def email_user_professor_uniqueness
    return errors.add(:email, 'has already been taken') if Professor.exists?(email:)
  end

  def uses_email?
    provider == 'email' || email.present?
  end

  def init_uid
    self.uid = email if uid.blank? && provider == 'email'
  end
end
