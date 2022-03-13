require 'rails_helper'

describe '/api/v1/users/:user_id/assigned_projects/:assigned_project_id/project_deliveries/:project_delivery_id/defects', type: :request do
  let!(:professor)     { create :professor }
  let!(:user)     { create :user, professor: professor }
  let!(:course)   { create :course }
  let!(:project)  { create :project }
  let!(:phase1)   { create :phase, first: true }
  let!(:phase2)   { create :phase }
  let!(:phase3)   { create :phase, last: true }
  let!(:course_project_instance) do
    create :course_project_instance, course: course, project: project
  end

  before do
    course.professors << professor
    course.students << user
    @assigned_project = create :assigned_project, course_project_instance: course_project_instance, user: user
    @project_delivery = create :project_delivery, assigned_project: @assigned_project
    @phase_instance1 = create :phase_instance, phase: phase1, project_delivery: @project_delivery
    @phase_instance2 = create :phase_instance, phase: phase2, project_delivery: @project_delivery
    @phase_instance3 = create :phase_instance, phase: phase2, project_delivery: @project_delivery
    @phase_instance4 = create :phase_instance, phase: phase3, project_delivery: @project_delivery

    # Creating defects
    @defects1 = create_list :defect, 2,  phase_instance: @phase_instance1
    @defects2 = create_list :defect, 3,  phase_instance: @phase_instance2
    @defects3 = create_list :defect, 4,  phase_instance: @phase_instance3
    @defects4 = create_list :defect, 2,  phase_instance: @phase_instance4
  end


  it 'returns success' do
    get api_v1_user_assigned_project_project_delivery_defects_path(user_id: user.id,
                                                                   assigned_project_id: @assigned_project.id,
                                                                   project_delivery_id: @project_delivery.id,
                                                                   phase_id: phase2.id),
      headers: auth_headers, as: :json
    expect(response).to have_http_status(:success)
  end

  it 'returns the defects from phase 2' do
    get api_v1_user_assigned_project_project_delivery_defects_path(user_id: user.id,
                                                                   assigned_project_id: @assigned_project.id,
                                                                   project_delivery_id: @project_delivery.id,
                                                                   phase_id: phase2.id),
      headers: auth_headers, as: :json
    result_ids = JSON.parse(response.body).map{ |elem| elem['id'] }
    expect(result_ids).to include(*@defects2.map(&:id))
    expect(result_ids).to include(*@defects3.map(&:id))
  end

  it 'does not include defects from other phases' do
    get api_v1_user_assigned_project_project_delivery_defects_path(user_id: user.id,
                                                                   assigned_project_id: @assigned_project.id,
                                                                   project_delivery_id: @project_delivery.id,
                                                                   phase_id: phase2.id),
      headers: auth_headers, as: :json
    result_ids = JSON.parse(response.body).map{ |elem| elem['id'] }
    expect(result_ids).not_to include(*@defects4.map(&:id))
    expect(result_ids).not_to include(*@defects1.map(&:id))
  end
end
