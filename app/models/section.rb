# frozen_string_literal: true

class Section < ApplicationRecord
  has_many :criteria, class_name: 'Criterion'

  validates :name, presence: true
end
