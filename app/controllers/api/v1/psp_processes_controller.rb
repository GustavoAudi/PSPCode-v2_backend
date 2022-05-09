module Api
  module V1
    class PspProcessesController < Api::V1::ApiController
      include Concerns::UserOrProfessorAuth

      def index
        @processes = PspProcess.includes(:phases).page params[:page]
      end
    end
  end
end
