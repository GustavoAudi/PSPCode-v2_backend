# encoding: utf-8

module Api
  module V1
    module Professors
      class UsersController < Api::V1::ApiController
        include Concerns::ProfessorAuth

        helper_method :course
        helper_method :course_project_instance

        def index
          @users = course.students.includes(:professor)
                         .includes(current_assigned_project: :course_project_instance)
          render 'api/v1/professors/users/index'
        end

        private

        def course
          @course ||= Course.find(params[:course_id])
        end

        def course_project_instance
          @course_project_instance ||= CourseProjectInstance.find(params[:course_project_instance_id])
        end
      end
    end
  end
end
