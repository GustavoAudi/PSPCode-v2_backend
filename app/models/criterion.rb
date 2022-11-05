# frozen_string_literal: true

class Criterion < ApplicationRecord
  self.table_name = 'criteria'
  belongs_to :section

  enum algorithm: {
    elapsed_time: 0,
    fix_time: 1,
    break_time: 2,
    plan_time: 3,
    empty_loc_and_empty_total: 4,
    time_conflicts: 5,
    discovered_time_fit: 6,
    phase_injected: 7
  }

  enum algorithm_type: {
    phase: 0,
    defect: 1
  }

  validates :section, presence: true
  validates :description, presence: true
  validates :order, presence: true, uniqueness: { scope: :section, message: 'should happen once per section' }
  validates :algorithm_type, presence:, if: proc { |c| c.algorithm.present? }
end
