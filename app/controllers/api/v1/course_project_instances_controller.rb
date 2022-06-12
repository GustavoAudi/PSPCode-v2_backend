# frozen_string_literal: true

module Api
  module V1
    class CourseProjectInstancesController < Api::V1::ApiController
      include Concerns::UserOrProfessorAuth

      helper_method :course_project_instance

      def show
        'api/v1/course_project_instances/show'
      end

      private

      def course_project_instance
        @course_project_instance ||= CourseProjectInstance.find(params[:id])
      end
    end
  end
end
