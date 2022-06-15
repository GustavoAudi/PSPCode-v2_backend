# frozen_string_literal: true

module Api
  module V1
    module Professors
      class AssignedProjectsController < Api::V1::ApiController
        include Concerns::ProfessorAuth

        skip_before_action :check_json_request
        helper_method :course_project_instance
        helper_method :assigned_project
        helper_method :statuses

        def create
          @assigned_project = course_project_instance.assigned_projects.create! assigned_project_params
          render 'api/v1/assigned_projects/show'
        end

        def approve_project
          current_professor.approve_project(assigned_project, message_params)
          render 'api/v1/statuses/index'
        end

        def reject_project
          current_professor.reject_project(assigned_project, message_params)
          render 'api/v1/statuses/index'
        end

        private

        def statuses
          @statuses ||= assigned_project.past_statuses.order(:id)
        end

        def assigned_project
          @assigned_project ||= AssignedProject.find(params[:assigned_project_id])
        end

        def assigned_project_params
          params.require(:assigned_project).permit(:user_id)
        end

        def message_params
          params.require(:message).permit(:text, :file).merge(sender: current_professor)
        end

        def course_project_instance
          @course_project_instance ||= CourseProjectInstance.find(params[:course_project_instance_id])
        end
      end
    end
  end
end
