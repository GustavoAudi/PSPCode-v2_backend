module Api
  module V1
    module Professors
      class CourseProjectInstancesController < Api::V1::ApiController
        include Concerns::ProfessorAuth
        helper_method :course

        def index
          @course_project_instances = course.course_projects
                                            .includes(project: :process)
                                            .order(:end_date)
          render 'api/v1/course_project_instances/index'
        end

        private

        def course
          @course ||= Course.find(params[:course_id])
        end
      end
    end
  end
end
