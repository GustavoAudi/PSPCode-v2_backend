
class Section < ApplicationRecord
  has_many :criteria, class_name: 'Criterion'
end
