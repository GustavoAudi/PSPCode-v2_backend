# frozen_string_literal: true

# == Schema Information
#
# Table name: phases
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  order       :integer
#  first       :boolean          default(FALSE)
#  last        :boolean          default(FALSE)
#

class Phase < ApplicationRecord
  # Processes that includes a specific phase
  has_many :psp_process_phases
  has_many :processes, source: :psp_process, through: :psp_process_phases
  has_many :phase_instances

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :order, presence: true,
                    uniqueness: true,
                    numericality: { only_integer: true }
  validate :order_inclusion
  validate :be_first_and_last_phase

  private

  def order_inclusion
    phase_count = Phase.count + 1
    return if order.blank? || order.positive? && order <= phase_count

    errors.add(:order, "should be included within 1 and #{phase_count}")
    errors.add(:order, 'should not be repeated with other phases')
  end

  def be_first_and_last_phase
    return unless first && last

    errors.add(:phase, 'can\'t be first and last phase at the same time')
  end
end
