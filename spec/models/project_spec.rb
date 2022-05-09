# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  process_id       :integer          not null
#  description_file :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_projects_on_process_id  (process_id)
#

require 'rails_helper'

describe Project do
  describe 'Associations' do
    it { is_expected.to belong_to(:process) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:process) }
  end
end
