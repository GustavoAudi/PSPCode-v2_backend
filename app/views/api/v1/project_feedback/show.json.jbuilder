# frozen_string_literal: true

project_feedback = @project_feedback

json.id project_feedback.id
json.approved project_feedback.approved
json.comment project_feedback.comment
json.delivered_date project_feedback.delivered_date
json.reviewed_date project_feedback.reviewed_date
json.grouped_corrections ProjectFeedback.group_corrections(project_feedback.corrections)
