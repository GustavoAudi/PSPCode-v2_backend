class Criterion < ApplicationRecord
  self.table_name = "criteria"
  belongs_to :section

  validates :section, presence: true
  validates :description, presence: true
end