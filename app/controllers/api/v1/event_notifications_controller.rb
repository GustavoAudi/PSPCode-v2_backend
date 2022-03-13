# encoding: utf-8

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
    end
  end
end
