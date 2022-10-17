
class ProjectFeedbackCriterionInstance < ApplicationRecord
  self.table_name = "project_fb_crt_instances"
  belongs_to :criterion
  belongs_to :project_feedback

end
