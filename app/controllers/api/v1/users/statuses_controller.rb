# frozen_string_literal: true

module Api
  module V1
    module Users
      class StatusesController < Api::V1::ApiController
        include Concerns::UserOrProfessorAuth

        helper_method :assigned_project
        helper_method :user
        helper_method :statuses

        def index
          statuses # Added to avoid rendering TemplateError when not found
          render 'api/v1/statuses/index'
        end

        private

        def assigned_project
          @assigned_project ||= user.assigned_projects.find(params[:assigned_project_id])
        end

        def user
          @user ||= User.find(params[:user_id])
        end

        def statuses
          @statuses ||= assigned_project.past_statuses.order(:id)
        end
      end
    end
  end
end
