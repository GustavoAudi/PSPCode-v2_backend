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

  scope :with_fix_defect,  -> { where 'fix_defect is not NULL' }

  def phase_detected
    phase_instance.phase
  end
end
