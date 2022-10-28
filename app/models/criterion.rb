# frozen_string_literal: true

class Criterion < ApplicationRecord
  self.table_name = 'criteria'
  belongs_to :section

  validates :section, presence: true
  validates :description, presence: true
  validates :order, uniqueness: { scope: :section, message: 'should happen once per section' }
end
