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

require 'rails_helper'

describe PspProcessPhase do
  describe 'Associations' do
    it { is_expected.to belong_to(:psp_process) }
    it { is_expected.to belong_to(:phase) }
  end
end
