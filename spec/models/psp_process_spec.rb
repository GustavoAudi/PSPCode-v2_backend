# frozen_string_literal: true

# == Schema Information
#
# Table name: psp_processes
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  has_plan_time :boolean          default(FALSE)
#  has_plan_loc  :boolean          default(FALSE)
#  has_pip       :boolean          default(FALSE)
#

require 'rails_helper'

describe PspProcess do
  describe 'Associations' do
    it { is_expected.to have_many(:psp_process_phases) }
    it { is_expected.to have_many(:phases).through(:psp_process_phases) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    context 'validate uniqueness' do
      subject(:psp_process) { build :psp_process }

      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    end
  end
end
