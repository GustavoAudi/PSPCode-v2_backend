# == Schema Information
#
# Table name: psp_process_phases
#
#  id             :integer          not null, primary key
#  phase_id       :integer
#  psp_process_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_psp_process_phases_on_phase_id        (phase_id)
#  index_psp_process_phases_on_psp_process_id  (psp_process_id)
#

class PspProcessPhase < ApplicationRecord
  belongs_to :psp_process
  belongs_to :phase

  validates :phase, uniqueness: { scope: :psp_process }
  # validate :first_phase_uniqueness
  # validate :last_phase_uniqueness

  private

  def first_phase_uniqueness
    return unless phase.first && psp_process.phases.exists?(first: true)

    errors.add(:psp_process, 'There\'s a first phase already added for this process')
  end

  def last_phase_uniqueness
    return unless phase.last && psp_process.phases.exists?(last: true)

    errors.add(:psp_process, 'There\'s a last phase already added for this process')
  end
end
