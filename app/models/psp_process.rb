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

class PspProcess < ApplicationRecord
  # Phases that a process follow
  has_many :psp_process_phases
  has_many :phases, through: :psp_process_phases

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
