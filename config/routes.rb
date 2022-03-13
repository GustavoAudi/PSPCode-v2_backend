Rails.application.routes.draw do
  devise_for :professors
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations:  'api/v1/registrations',
    sessions:  'api/v1/sessions',
    passwords:  'api/v1/passwords'
  }

  root to: 'rails_admin/main#dashboard'

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      devise_scope :user do
        get :status, to: 'api#status'

        resources :psp_processes, only: :index
        resources :users, only: :show do
          resources :assigned_projects, only: %i(create show index), module: :users do
            get :first, on: :collection
            post :start_project
            post :submit_project
            post :start_redeliver
            resources :project_deliveries, only: %i(update show) do
                resources :defects, only: :index, module: :project_deliveries
              resources :phase_instances, only: %i(create update index destroy) do
                resources :defects, only: %i(create update index destroy)
              end
              get 'summary'
            end
            resources :messages, only: %i(create index)
            resources :statuses, only: %i(index)
          end
        end

        resources :courses, only: %i(index), module: :professors do
          resources :course_project_instances, only: %i(index) do
            resources :assigned_projects, only: %i(create) do
              put :approve_project
              put :reject_project
            end
            resources :users, only: %i(index)
          end
        end

        resources :courses, only: [] do
          resources :users, only: %i(index), module: :courses
        end

        resources :course_project_instances, only: %i(show)
        resources :event_notifications, only: %i(index)
        resources :message_notifications, only: %i(index)

        resource :professor, only: :update
        resource :user, only: :update do
          get :profile
          controller :sessions do
            post :facebook, on: :collection
          end
        end
      end
    end
  end
end
