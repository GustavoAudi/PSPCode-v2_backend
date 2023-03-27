# frozen_string_literal: true

module Api
  module V1
    module Users
      class ProjectFeedbackController < Api::V1::ApiController
        include Concerns::UserOrProfessorAuth

        helper_method :project_delivery
        helper_method :user

        def create
          p_f = ProjectFeedback.create! delivered_date: Date.today, project_delivery: project_delivery
          Criterion.all.each do |c|
            if assigned_project.process.name.eql?('PSP0.1')
              Correction.create! criterion: c, project_feedback: p_f
            else
              Correction.create! criterion: c, project_feedback: p_f unless c.only_in_psp01
            end
          end
          render 'api/v1/project_feedback/success_msg'
        end

        def show
          return render 'api/v1/project_feedback/not_found_error', status: 404 unless project_feedback.present?

          @phase_instances = project_delivery.phase_instances.order(:id).page params[:page]
          @project_feedback = project_delivery.project_feedback
          render 'api/v1/project_feedback/show'
        end

        def update
          return render 'api/v1/project_feedback/not_found_error', status: 404 unless project_feedback.present?

          project_feedback.update(project_feedback_params)

          if project_feedback.reviewed_date.present?
            if project_feedback.approved.present?
              @professor_authenticated.approve_project(assigned_project)
            else
              @professor_authenticated.reject_project(assigned_project)
            end
          end

          render 'api/v1/project_feedback/success_msg'
        end

        def destroy
          return render 'api/v1/project_feedback/not_found_error', status: 404 unless project_feedback.present?

          project_feedback.destroy!
          render 'api/v1/project_feedback/success_msg'
        end

        private

        def project_feedback_params
          all_new_corrections = []
          grouped_corrections = params[:grouped_corrections]
          if grouped_corrections.present?
            grouped_corrections.each do |group|
              all_new_corrections.concat(group[:corrections].map { |c| Correction.to_h(c).compact })
            end
          end

          params.require('project_feedback')
                .permit(:comment, :approved, :reviewed_date)
                .merge(corrections_attributes: all_new_corrections)
                .compact
        end

        def project_feedback
          @project_feedback ||= project_delivery.project_feedback
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
