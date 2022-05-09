# encoding: utf-8

module Api
  module V1
    module Users
      class MessagesController < Api::V1::ApiController
        include Concerns::UserOrProfessorAuth

        helper_method :assigned_project
        helper_method :user

        # TODO, add tests
        def create
          @message = assigned_project.messages.create!(message_params)
          render 'api/v1/messages/create'
        end

        def index
          @messages = assigned_project.messages.page params[:page]
          render 'api/v1/messages/index'
        end

        private

        def assigned_project
          @assigned_project ||= user.assigned_projects.find(params[:assigned_project_id])
        end

        def message_params
          params.require(:message).permit(:text,
                                          :message_type).merge!(sender: current_authenticated)
        end

        def user
          @user ||= User.find(params[:user_id])
        end
      end
    end
  end
end
