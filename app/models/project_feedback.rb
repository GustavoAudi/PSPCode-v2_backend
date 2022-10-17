

class ProjectFeedback < ApplicationRecord
  has_many :criteria, class_name: 'ProjectFeedbackCriterionInstance'
  belongs_to :project_delivery
end
