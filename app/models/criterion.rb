

class Criterion < ApplicationRecord
  self.table_name = "criteria"
  belongs_to :section
end