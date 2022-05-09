module Api
  module Concerns
    module UserOrProfessorAuth
      extend ActiveSupport::Concern

      included do
        before_action :authenticate_user_or_professor!, except: :status
        before_action :check_user_authorization
      end

      def authenticate_user_or_professor!
        return if current_user || current_professor

        render json: { errors: [I18n.t('devise.failure.unauthenticated')] }, status: 401
      end

      def check_user_authorization
        if user_signed_in? && params[:user_id].present?
          return if params[:user_id].to_i == current_user.id

          raise Exceptions::AuthorizationException.new('user_id'),
                'Unauthorized access for user with id'
        end
      end

      def current_authenticated
        current_user || current_professor
      end
    end
  end
end
