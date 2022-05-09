module Api
  module V1
    module Courses
      class UsersController < Api::V1::ApiController
        helper_method :course

        # TODO, make this better, views, etc
        def index
          @users = course.students.includes(:professor)
                         .includes(current_assigned_project: :course_project_instance)
          render 'api/v1/courses/users/index'
        end

        private

        def course
          @course ||= Course.find(params[:course_id])
        end
      end
    end
  end
end
