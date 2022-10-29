# frozen_string_literal: true

class Criterion < ApplicationRecord
  self.table_name = 'criteria'
  belongs_to :section

  enum algorithm: {
    elapsed_time: 0,
    fix_time: 1,
    break_time: 2,
    plan_time: 3,
    empty_loc: 4,
    empty_total: 5,
    phase_conflicts: 6
  }

  validates :section, presence: true
  validates :description, presence: true
  validates :algorithm, presence: true
  validates :order, uniqueness: { scope: :section, message: 'should happen once per section' }
end
