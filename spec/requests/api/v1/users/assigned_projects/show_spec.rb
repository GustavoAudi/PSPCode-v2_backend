require 'rails_helper'

describe 'GET api/v1/users/:user_id/assigned_projects/:id',
         type: :request do
  let(:user) { create(:user) }
  let(:project) { create_list :project }
  let(:course) { create :course }
  let(:course_project_instance) do
  end

  # it 'returns success' do
  #   get api_v1_user_path(id: another_user.id), headers: auth_headers, as: :json
  #   expect(response).to have_http_status(:success)
  # end

  # it 'returns user\'s data' do
  #   get api_v1_user_path(id: another_user.id), headers: auth_headers, as: :json

  #   expect(json[:user][:id]).to eq another_user.id
  #   expect(json[:user][:first_name]).to eq another_user.first_name
  # end
end
