module Api
  module V1
    module Users
      module ProjectDeliveries
        class DefectsController < Api::V1::ApiController
          include Concerns::UserOrProfessorAuth

          helper_method :user
          helper_method :defects
          helper_method :phase
          helper_method :assigned_project
          helper_method :project_delivery

          def index
            render 'api/v1/defects/index'
          end

          private

          def defects
            @defects ||= project_delivery.defects_from_phase(phase)
          end

          def user
            User.find(params[:user_id])
          end

          def phase
            Phase.find(params[:phase_id])
          end

          def assigned_project
            user.assigned_projects.find(params[:assigned_project_id])
          end

          def project_delivery
            assigned_project.project_deliveries.find(params[:project_delivery_id])
          end
        end
      end
    end
  end
end
