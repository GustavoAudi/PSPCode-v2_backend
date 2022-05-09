# == Schema Information
#
# Table name: phase_instances
#
#  id                  :integer          not null, primary key
#  start_time          :datetime
#  end_time            :datetime
#  phase_id            :integer
#  project_delivery_id :integer          not null
#  interruption_time   :integer          default(0)
#  plan_time           :integer          default(0)
#  plan_loc            :integer          default(0)
#  actual_base_loc     :integer          default(0)
#  modified            :integer          default(0)
#  deleted             :integer          default(0)
#  reused              :integer          default(0)
#  new_reusable        :integer          default(0)
#  total               :integer          default(0)
#  pip_problem         :string           default("")
#  pip_proposal        :string           default("")
#  pip_notes           :string           default("")
#  comments            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  elapsed_time        :integer          default(0)
#  first               :boolean          default(FALSE)
#  last                :boolean          default(FALSE)
#
# Indexes
#
#  index_phase_instances_on_phase_id             (phase_id)
#  index_phase_instances_on_project_delivery_id  (project_delivery_id)
#

class PhaseInstance < ApplicationRecord
  has_many :defects, dependent: :destroy
  belongs_to :project_delivery
  # The real phase that correspond to this instance, e.g: PLAN
  # TODO, check if this does not need a has_many from the other side with dependent destroy
  belongs_to :phase

  validate :valid_elapsed_time
  validate :valid_time_range

  before_validation :update_elapsed_time
  before_save :assign_first_and_last_attr, if: :phase_id_changed?

  # Delete all the defects that were injected in the same Phase p if this is the last
  # PhaseInstance pi of type Phase p
  after_destroy :defect_deletion_consistence
  after_update :defect_deletion_consistence, if: :phase_id_changed?

  private

  def valid_elapsed_time
    return unless elapsed_time.negative?

    errors.add(:elapsed_time,
               'should be a positive number (end_time - start_time - interruption_time)')
  end

  def valid_time_range
    return unless start_time.present? && end_time.present? && start_time > end_time

    errors.add(:time_range, 'start_time cannot be higher than end_time')
  end

  def defect_deletion_consistence
    return unless project_delivery.phase_instances.where(phase_id: phase_id_was).count.zero?

    project_delivery.destroy_defects_injected_in_phase(phase_id_was)
  end

  def update_elapsed_time
    return unless end_time_changed? || start_time_changed? || interruption_time_changed?

    self.elapsed_time = if start_time.present? && end_time.present?
                          ((end_time.to_i - start_time.to_i) / 60) - interruption_time.to_i
                        else
                          0
                        end
  end

  def assign_first_and_last_attr
    self.first = phase.first
    self.last = phase.last
  end
end
