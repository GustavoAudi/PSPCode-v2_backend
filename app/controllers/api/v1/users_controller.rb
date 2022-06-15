# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApiController
      include Concerns::UserOrProfessorAuth
      helper_method :user

      def show; end

      def profile
        render :show
      end

      def update
        user.update!(user_params)
        render :show
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :programming_language, :last_seen_event_notification, :last_seen_message_notification, :password, :have_a_job, :job_role, :academic_experience, :programming_experience, :collegue_career_progress, :approved_subjects)
      end

      def user
        @user ||= user_id.present? ? User.find(user_id) : current_user
      end

      def user_id
        params[:id]
      end
    end
  end
end
