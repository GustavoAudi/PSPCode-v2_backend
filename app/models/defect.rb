# frozen_string_literal: true

# == Schema Information
#
# Table name: defects
#
#  id                :integer          not null, primary key
#  discovered_time   :datetime         not null
#  phase_injected_id :integer          not null
#  phase_instance_id :integer          not null
#  defect_type       :integer          not null
#  fix_defect        :integer
#  fixed_time        :datetime         not null
#  description       :string           not null
#
# Indexes
#
#  index_defects_on_phase_injected_id  (phase_injected_id)
#  index_defects_on_phase_instance_id  (phase_instance_id)
#

class Defect < ApplicationRecord
  enum defect_type: ['Documentation', 'Syntax', 'Build, Package', 'Assignment', 'Interface', 'Checking', 'Data', 'Function', 'System', 'Environment']

  default_scope { order(:id) }

  belongs_to :phase_injected, class_name: 'Phase', foreign_key: 'phase_injected_id'
  belongs_to :phase_instance

  validates :discovered_time,
            :phase_injected_id,
            :phase_instance_id,
            :defect_type,
            :fixed_time,
            :description, presence: true

  scope :with_fix_defect, -> { where 'fix_defect is not NULL' }

  ## start observations for professor

  ## algorithms
  def build_discovered_time_fit_obs
    if phase_instance.present? && phase_instance.start_time.present? && phase_instance.end_time.present? && discovered_time.present? &&
      (discovered_time < phase_instance.start_time || discovered_time > phase_instance.end_time)
      return "The discovered time is outside the phase's total time."
    end

    nil
  end

  def build_phase_injected_obs(phase_instances)
    post_phases = false
    if phase_instances.present?
      phase_instances.each do |phase_instance_it|
        if phase_instance_it.id == phase_instance.id
          post_phases = true
        end

        if phase_injected.present? &&
          phase_injected.name.present? &&
          phase_instance_it.phase.present? &&
          phase_instance_it.phase.name.present? &&
          phase_injected.name == phase_instance_it.phase.name

          return 'The phase where the defect was injected should be prior to this one' if post_phases
          return nil
        end
      end
    end
    nil
  end

  ## end observations

  private

  def phase_detected
    phase_instance.phase
  end
end
