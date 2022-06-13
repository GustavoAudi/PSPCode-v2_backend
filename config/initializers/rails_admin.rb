# frozen_string_literal: true

require 'rails_admin/config/actions/export_course_data'

RailsAdmin::Config::Actions.register(:export_course_data, 'RailsAdmin::Config::Actions::ExportCourseData')

RailsAdmin.config do |config|
  # Provide application name
  config.main_app_name = ['PSP admin', '']

  config.asset_source = :sprockets
  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :professor
  end
  config.current_user_method(&:current_professor)

  config.included_models = %w[ProfessorCourse Phase Course PspProcess Professor Project User CourseProjectInstance]

  ## == Needed to reload in dev ENV ==
  config.parent_controller = ApplicationController.to_s

  # Display empty fields
  config.compact_show_view = false

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    show_in_app
    export_course_data

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model CourseProjectInstance do
    visible false
    edit do
      field :project
      field :start_date
      field :end_date
    end
  end

  config.model ProfessorCourse do
    visible false
  end

  config.model User do
    label 'Student'
    list do
      field :first_name
      field :last_name
      field :created_at do
        label 'Member since'
      end
      field :course
      field :professor do
        'Tutor'
      end
    end

    show do
      field :id
      field :first_name
      field :last_name
      field :email
      field :approved_subjects, :pg_int_array
      field :programming_language
      field :have_a_job
      field :job_role
      field :academic_experience
      field :programming_experience
      field :collegue_career_progress
      field :course
      field :professor
      field :sign_in_count
      field :current_sign_in_ip
      field :last_sign_in_ip
      field :created_at do
        label 'Member since'
      end
      field :updated_at
    end

    edit do
      field :first_name
      field :last_name
      field :email
      field :professor
      field :course
      field :programming_language
      field :have_a_job
      field :job_role
      field :academic_experience
      field :programming_experience
      field :collegue_career_progress
      field :approved_subjects, :pg_int_array
    end
  end

  config.model Professor do
    list do
      field :id
      field :first_name
      field :last_name
      field :created_at do
        label 'member since'
      end
      field :updated_at
    end

    show do
      field :id
      field :first_name
      field :last_name
      field :email
      field :additional_notes
      field :current_sign_in_ip
      field :last_sign_in_ip
      field :created_at do
        label 'Member since'
      end
      field :updated_at
    end

    edit do
      field :first_name
      field :last_name
      field :email
      field :password
      field :additional_notes
    end
  end

  config.model Project do
    list do
      field :id
      field :name
      field :process
      field :created_at
      field :updated_at
    end

    show do
      field :name
      field :process
      field :description_file
      field :created_at
      field :updated_at
    end

    edit do
      field :name
      field :process
      field :description_file
    end
  end

  config.model PspProcess do
    label 'Process'
    list do
      field :name
      field :has_plan_time
      field :has_plan_loc
      field :has_pip
    end

    show do
      field :name
      field :phases
      field :has_plan_time
      field :has_plan_loc
      field :has_pip
      field :created_at
      field :updated_at
    end

    edit do
      field :name
      field :phases
      field :has_plan_time
      field :has_plan_loc
      field :has_pip
    end
  end

  config.model Phase do
    list do
      field :name
      field :description
      field :order
      field :first
      field :last
    end

    show do
      field :name
      field :description
      field :order
      field :first
      field :last
    end

    edit do
      field :name
      field :description, :text do
        html_attributes do
          { rows: 6, cols: 50 }
        end
      end
      field :order do
        help 'Suggested order that phases will be displayed for students'
      end
      field :first
      field :last
    end
  end

  config.model Course do
    list do
      field :name
      field :start_date
      field :end_date
      field :created_at
    end

    show do
      field :name
      field :description
      field :start_date
      field :end_date
      field :professors
      field :projects
      field :additional_notes
      field :created_at
    end

    edit do
      field :name
      field :start_date
      field :end_date
      field :description, :text do
        html_attributes do
          { rows: 6, cols: 50 }
        end
      end
      field :additional_notes, :text do
        html_attributes do
          { rows: 6, cols: 50 }
        end
      end
      field :professors
      field :course_projects
    end
  end
end
