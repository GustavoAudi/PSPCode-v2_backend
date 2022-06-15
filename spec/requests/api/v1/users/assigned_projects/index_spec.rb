# frozen_string_literal: true

require 'rails_helper'

describe 'GET api/v1/users/:user_id/projects', type: :request do
  let(:user)     { create :user }
  let(:projects) { create_list :project, 2 }
  let(:course)   { create :course }
  let(:course_project_instances) do
    course_project_instances = []
    projects.each do |project|
      course_project_instances.push(CourseProjectInstance.create!(project: project,
                                                                  course: course,
                                                                  name: Faker::Name.name,
                                                                  start_date: 2.days.ago,
                                                                  end_date: Date.today))
    end
    course_project_instances
  end
  let!(:assigned_projects) do
    assigned_projects = []
    course_project_instances.each do |course_project_instance|
      assigned_projects.push(create(:assigned_project,
                                    user: user,
                                    course_project_instance: course_project_instance))
    end
    assigned_projects
  end

  # it 'returns success' do
  #   get api_v1_user_assigned_projects_path(user_id: user.id), headers: auth_headers, as: :json
  #   expect(response).to have_http_status(:success)
  # end

  # it 'returns my projects' do
  #   get api_v1_user_assigned_projects_path(user_id: user.id), headers: auth_headers, as: :json
  #   projects_array = JSON.parse response.body
  #   expect(projects_array.map { |hash| hash['key'] })
  #     .to match_array(assigned_projects.pluck(:id))
  # end
end
