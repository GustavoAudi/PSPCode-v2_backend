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

require 'rails_helper'

describe PhaseInstance do
  describe 'Associations' do
    it { is_expected.to belong_to(:project_delivery) }
    it { is_expected.to belong_to(:phase) }
    it { is_expected.to have_many(:defects).dependent(:destroy) }
  end

  describe 'validations' do
    # it { is_expected.to validate_presence_of(:start_time) }
    # it { is_expected.to validate_presence_of(:end_time) }
    # it { is_expected.to validate_presence_of(:phase) }
    # it { is_expected.to validate_presence_of(:project_delivery) }
  end
end
