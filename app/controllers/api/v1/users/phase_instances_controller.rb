# encoding: utf-8

module Api
  module V1
    module Users
      class PhaseInstancesController < Api::V1::ApiController
        include Concerns::UserOrProfessorAuth

        helper_method :project_delivery
        helper_method :phase_instance
        helper_method :user

        def create
          @phase_instance = project_delivery.phase_instances.create!
          render 'api/v1/phase_instances/show'
        end

        def update
          phase_instance.update! phase_instance_params
          render 'api/v1/phase_instances/show'
        end

        def index
          @phase_instances = project_delivery.phase_instances.order(:id).page params[:page]
          render 'api/v1/phase_instances/index'
        end

        def destroy
          @phase_instance = phase_instance.destroy!
          render 'api/v1/phase_instances/show'
        end

        private

        def phase_instance_params
          params.require(:phase_instance).permit(:start_time,
                                                 :end_time,
                                                 :phase_id,
                                                 :interruption_time,
                                                 :plan_time,
                                                 :plan_loc,
                                                 :actual_base_loc,
                                                 :modified,
                                                 :deleted,
                                                 :reused,
                                                 :new_reusable,
                                                 :total,
                                                 :pip_problem,
                                                 :pip_proposal,
                                                 :pip_notes,
                                                 :comments)
        end

        def phase_instance
          @phase_instance ||= project_delivery.phase_instances.find(params[:id])
        end

        def user
          @user ||= User.find(params[:user_id])
        end

        def project_delivery
          @project_delivery ||= assigned_project.project_deliveries.find(params[:project_delivery_id])
        end

        def assigned_project
          @assigned_project ||= AssignedProject.find(params[:assigned_project_id])
        end
      end
    end
  end
end
