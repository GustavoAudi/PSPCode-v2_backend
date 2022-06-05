# == Schema Information
#
# Table name: assigned_projects
#
#  id                         :integer          not null, primary key
#  course_project_instance_id :integer          not null
#  user_id                    :integer          not null
#  status                     :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  process_id                 :integer
#
# Indexes
#
#  index_assigned_projects_on_course_project_instance_id  (course_project_instance_id)
#  index_assigned_projects_on_process_id                  (process_id)
#  index_assigned_projects_on_user_id                     (user_id)
#

class AssignedProject < ApplicationRecord
  enum status: %i(assigned working being_corrected approved need_correction)
  has_many :project_deliveries, dependent: :destroy
  has_many :past_statuses, class_name: 'Status'
  has_many :messages, dependent: :destroy

  belongs_to :user
  belongs_to :course_project_instance, counter_cache: true
  counter_culture :course_project_instance,
                  column_name: proc { |model| "#{model.status}_count" },
                  column_names: {
                    ["assigned_projects.status = ?", 0] => 'assigned_count',
                    ["assigned_projects.status = ?", 1] => 'working_count',
                    ["assigned_projects.status = ?", 2] => 'being_corrected_count',
                    ["assigned_projects.status = ?", 3] => 'approved_count',
                    ["assigned_projects.status = ?", 4] => 'assigned_count',
                  }

  # Process that follows the assigned_project
  belongs_to :process, class_name: 'PspProcess'

  validates :user, :course_project_instance, presence: true
  validate :user_course_project_instance_consistency
  validate :status_flow

  before_validation :assign_status, on: :create
  # TODO, evaluate if it wouldn't be better to clone attrs in this entity
  # to avoid issues if the process
  # is updated (deletion can be manage with soft deletions).
  # Added to avoid multiple joins when rendering project list for a student
  before_save :assign_process
  after_save :create_status_record, if: :saved_change_to_status?
  after_save :create_notification, if: :saved_change_to_status?
  after_save :delete_locs_first_project, if: :saved_change_to_status?
  after_save :update_user_current_assigned_project, if: :saved_change_to_status?
  after_create :create_project_delivery

  def assigned_datetime
    past_statuses.first&.created_at
  end

  # Create project delivery that the user will be editing
  # Create first dummy phase_instance for the project_delivery
  def create_project_delivery
    project_delivery = ProjectDelivery.create! assigned_project: self
    project_delivery.phase_instances.create!
  end

  # Check that generate_new_version has to be done
  # before updating the status of the assigned project
  # to associate the new status with the correct version
  def generate_redeliver
    ActiveRecord::Base.transaction do
      generate_new_version
      update!(status: :working)
    end
  end

  def current_project_delivery
    project_deliveries&.last
  end

  private

  def delete_locs_first_project
    return unless status == 'need_correction'
    assigned_projects = user.assigned_projects
    if assigned_projects.where('id < ?', id).count == 1
      assigned_projects.first&.current_project_delivery&.phase_instances&.last&.update!(new_reusable: 0, total: 0)
    end
  end

  def generate_new_version
    last_project_delivery = project_deliveries.last
    new_project_delivery = last_project_delivery.dup
    new_project_delivery.save!
    defect_equivalent_hash = {}
    last_project_delivery.phase_instances.order(:id).each do |phase_instance|
      new_phase_instance = phase_instance.dup
      new_phase_instance.project_delivery = new_project_delivery
      new_phase_instance.save!
      phase_instance.defects.order(:id).each do |defect|
        new_defect = defect.dup
        new_defect.phase_instance = new_phase_instance
        new_defect.save!
        defect_equivalent_hash[defect.id] = new_defect.id
      end
    end

    new_project_delivery.defects.with_fix_defect.each do |defect|
      defect.update! fix_defect: defect_equivalent_hash[defect.fix_defect]
    end
  end

  def user_course_project_instance_consistency
    if course_project_instance.present? && user.present?
      return if course_project_instance.students.include? user
      errors.add(:user, 'Must belong to the course')
    end
  end

  def create_notification
    case status
    when 'assigned'
      EventNotification.create! originator: user.professor,
                                receiver: user,
                                status: status,
                                assigned_project: self,
                                project_delivery: project_deliveries.last
    when 'being_corrected'
      EventNotification.create! originator: user,
                                receiver: user.professor,
                                status: status,
                                assigned_project: self,
                                project_delivery: project_deliveries.last
    when 'approved'
      EventNotification.create! originator: user.professor,
                                receiver: user,
                                status: status,
                                assigned_project: self,
                                project_delivery: project_deliveries.last
    when 'need_correction'
      EventNotification.create! originator: user.professor,
                                receiver: user,
                                status: status,
                                assigned_project: self,
                                project_delivery: project_deliveries.last
    end
  end

  def update_user_current_assigned_project
    user.update! current_assigned_project: self
  end

  def status_flow
    return unless status_changed?
    error_msg = 'unpermitted status flow'
    case status
    when 'assigned'
      errors.add(:status, error_msg) unless status_was == nil
    when 'working'
      errors.add(:status, error_msg) unless status_was == 'assigned' ||
                                            status_was == 'need_correction'
    when 'being_corrected'
      errors.add(:status, error_msg) unless status_was == 'working'

    when 'approved', 'need_correction'
      errors.add(:status, error_msg) unless status_was == 'being_corrected'
    end
  end

  def assign_status
    self.status = self.class.statuses['assigned']
  end

  def assign_process
    project = course_project_instance.project
    return unless project.present? && project.process.present?
    self.process = project.process
  end

  def create_status_record
    past_statuses.create! user: user, value: status
  end
end
