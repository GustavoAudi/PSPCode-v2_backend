module Api
  module V1
    class ProfessorsController < Api::V1::ApiController
      include Concerns::ProfessorAuth

      helper_method :professor

      def update
        professor.update!(professor_params)
        render :show
      end

      private

      def professor_params
        params.require(:professor).permit(:last_seen_event_notification,
                                          :last_seen_message_notification)
      end

      def professor
        @professor ||= current_professor
      end
    end
  end
end
