# frozen_string_literal: true

module Api
  module V1
    module Users
      class ProjectDeliveriesController < Api::V1::ApiController
        include Concerns::UserOrProfessorAuth

        skip_before_action :check_json_request
        helper_method :assigned_project
        helper_method :project_delivery
        helper_method :user

        def summary
          render json: project_delivery.summary(params[:project_delivery_id], user.id,
                                                assigned_project.id)
        end

        # TODO, needs tests
        def show
          render 'api/v1/project_deliveries/show'
        end

        def update
          project_delivery.update! project_delivery_params
          render 'api/v1/project_deliveries/show'
        end

        private

        def assigned_project
          @assigned_project ||= user.assigned_projects.find(params[:assigned_project_id])
        end

        def project_delivery_params
          params.require(:project_delivery).permit(:file)
        end

        def project_delivery
          @project_delivery ||= assigned_project.project_deliveries.find(params[:id] || params[:project_delivery_id])
        end

        def user
          @user ||= User.find(params[:user_id])
        end
      end
    end
  end
end
