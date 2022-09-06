# frozen_string_literal: true

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

  ## start observations for professor
  ONE_DAY = 1440
  PLAN_ORDER = 1
  CODE_ORDER = 3
  POST_MORTEN_ORDER = 6

  def build_elapsed_time_obs
    'The stage lasts more than 24 hours.' if phase.present? && phase.order != CODE_ORDER && build_total_without_break_time > ONE_DAY
  end

  def build_fix_time_obs
    'Fix time is greater than stage total time.' if build_total_fix_time > build_total_without_break_time
  end

  def build_break_time_obs
    'The interruption time shouldn’t be that long.' if interruption_time > build_total_without_fix_time
  end

  def build_plan_time_obs
    return unless phase.present? && phase.order == PLAN_ORDER
    return 'The estimated time is not defined.' if !plan_time.present? || plan_time.zero?

    'The estimated time is greater than 24hrs.' if plan_time > ONE_DAY
  end

  def build_empty_loc_obs
    'Plan LOCs are not defined.' if phase.present? && phase.order == PLAN_ORDER && (!plan_loc.present? || plan_loc.zero?)
  end

  def build_empty_total_obs
    'Total project time is not defined.' if phase.present? && phase.order == POST_MORTEN_ORDER && (!total.present? || total.zero?)
  end

  def build_phase_conflicts_obs(phase_instances)
    res1 = res2 = nil
    [res1, res2] unless phase_instances.present?

    post_phases, first_check, second_check = false
    phase_instances.each do |phase_instance_it|
      if phase_instance_it.id == id
        post_phases = true
        next
      end
      name = phase_instance_it.phase.present? && phase_instance_it.phase.name.present? ? phase_instance_it.phase.name : 'undefined'
      first_check = phase_instance_it.start_time <= end_time if phase_instance_it.start_time.present? && end_time.present?
      second_check = phase_instance_it.end_time >= start_time if phase_instance_it.end_time.present? && start_time.present?
      if post_phases
        if first_check
          res1 = res1.present? ? res1 + ", #{name}" : "This phase ends after #{name}"
        end
      elsif second_check
        res2 = res2.present? ? res2 + ", #{name}" : "This phase starts before #{name}"
      end
    end
    res1 += ' starts.' if res1.present?
    res2 += ' ends.' if res2.present?
    [res1, res2]
  end

  ## end observations

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

    self.elapsed_time = build_total_without_break_time
  end

  def build_total_without_break_time
    total_without_break_time = build_total_time - interruption_time
    if total_without_break_time.negative?
      0
    else
      total_without_break_time
    end
  end

  def build_total_without_fix_time
    total_without_fix_time = build_total_time - build_total_fix_time
    if total_without_fix_time.negative?
      0
    else
      total_without_fix_time
    end
  end

  def build_total_time
    if start_time.present? && end_time.present?
      (end_time - start_time) / 60
    else
      0
    end
  end

  def build_total_fix_time
    total_fix_time = 0
    if defects.present?
      defects.each do |defect|
        total_fix_time += (defect.fixed_time - defect.discovered_time) / 60
      end
    end
    total_fix_time
  end

  def assign_first_and_last_attr
    self.first = phase.first
    self.last = phase.last
  end
end
