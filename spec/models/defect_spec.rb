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

require 'rails_helper'

describe Defect do
  describe 'Associations' do
    it { is_expected.to belong_to(:phase_injected) }
    # it { is_expected.to belong_to(:phase_detected) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:discovered_time) }
    it { is_expected.to validate_presence_of(:phase_injected_id) }
    it { is_expected.to validate_presence_of(:phase_instance_id) }
    it { is_expected.to validate_presence_of(:defect_type) }
    it { is_expected.to validate_presence_of(:fixed_time) }
    it { is_expected.to validate_presence_of(:description) }
  end
end
