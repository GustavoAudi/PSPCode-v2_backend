module Api
  module V1
    class EventNotificationsController < Api::V1::ApiController
      include Concerns::UserOrProfessorAuth

      helper_method :current_authenticated

      def index
        @event_notifications = current_authenticated.event_notifications
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
