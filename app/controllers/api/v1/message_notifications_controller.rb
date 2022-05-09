module Api
  module V1
    class MessageNotificationsController < Api::V1::ApiController
      include Concerns::UserOrProfessorAuth

      helper_method :current_authenticated

      def index
        @message_notifications = current_authenticated.message_notifications
                                                      .order(id: :desc)
                                                      .page(params[:page])
                                                      .per(params[:limit])
      end

      def edit
        @route = Route.find(params[:id])
      end
    end
  end
end
