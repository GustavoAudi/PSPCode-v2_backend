module Api
  module V1
    module Users
      class AssignedProjectsController < Api::V1::ApiController
        include Concerns::UserOrProfessorAuth

        helper_method :assigned_project
        helper_method :user
        helper_method :statuses

        def first
          @assigned_project = user.first_approved_assigned_project
          render 'api/v1/assigned_projects/first'
        end

        def start_project
          user.start_working(params[:assigned_project_id])
          render 'api/v1/statuses/index'
        end

        def submit_project
          user.submit_project(params[:assigned_project_id])
          render 'api/v1/statuses/index'
        end

        def start_redeliver
          user.start_redeliver(params[:assigned_project_id])
          render 'api/v1/statuses/index'
        end

        def show
          assigned_project # Added to avoid rendering TemplateError when not found
          render 'api/v1/assigned_projects/show'
        end

        def index
          @assigned_projects = user
                               .assigned_projects
                               .includes(:course_project_instance)
                               .includes(:process)
                               .order(:id)
                               .page params[:page]
          render 'api/v1/assigned_projects/index'
        end

        def edit
          @route = Route.find(params[:id])
        end

        private

        def assigned_project
          @assigned_project ||= user.assigned_projects.find(params[:id] ||
                                                            params[:assigned_project_id])
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
