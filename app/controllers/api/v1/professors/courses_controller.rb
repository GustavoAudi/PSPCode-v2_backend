# encoding: utf-8

module Api
  module V1
    module Professors
      class CoursesController < Api::V1::ApiController
        include Concerns::ProfessorAuth

        def index
          @courses = current_professor.courses.order(:id)
          render 'api/v1/courses/index'
        end
      end
    end
  end
end
