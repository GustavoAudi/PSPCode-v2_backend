# == Schema Information
#
# Table name: project_deliveries
#
#  id                  :integer          not null, primary key
#  file                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  assigned_project_id :integer          not null
#  version_number      :integer          default(1)
#
# Indexes
#
#  index_project_deliveries_on_assigned_project_id  (assigned_project_id)
#

require 'rails_helper'

describe ProjectDelivery do
  describe 'Associations' do
    it { is_expected.to belong_to(:assigned_project) }
    it { is_expected.to have_many(:phase_instances).dependent(:destroy) }
  end
end
