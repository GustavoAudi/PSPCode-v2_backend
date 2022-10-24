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
            if assigned_project.process.name.eql?("PSP0.1")
              Correction.create! criterion: c, project_feedback: p_f
            else
              unless c.only_in_psp01
                Correction.create! criterion: c, project_feedback: p_f
              end
            end
          end
        end

        def show
          @project_feedback = project_delivery.project_feedback
          render 'api/v1/project_feedback/show'
        end

        def update
          all_new_corrections = []
          params[:grouped_corrections].as_json.each do |group|
            all_new_corrections.concat(group["corrections"].map { |c| Correction.to_h(c) })
          end

          project_feedback.update(comment: params[:comment],
                                  approved: params[:approved],
                                  reviewed_date: params[:reviewed_date],
                                  corrections_attributes: all_new_corrections)
        end

        def destroy
          project_feedback.destroy!
        end

        private

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
