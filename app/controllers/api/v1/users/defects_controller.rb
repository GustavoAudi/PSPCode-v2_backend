# frozen_string_literal: true

module Api
  module V1
    module Users
      class DefectsController < Api::V1::ApiController
        include Concerns::UserOrProfessorAuth

        helper_method :phase_instance
        helper_method :defect
        helper_method :defects

        def create
          @defect = phase_instance.defects.create! defect_params
          render 'api/v1/defects/index'
        end

        def update
          defect.update! defect_params
          render 'api/v1/defects/index'
        end

        def index
          @phase_instances = phase_instance.project_delivery.phase_instances.order(:id).page params[:page]
          render 'api/v1/defects/index'
        end

        def destroy
          @defect = defect.destroy!
          render 'api/v1/defects/index'
        end

        private

        def defect_params
          params.require(:defect).permit(:discovered_time,
                                         :phase_injected_id,
                                         :defect_type,
                                         :fix_defect,
                                         :fixed_time,
                                         :description)
        end

        def defect
          @defect ||= phase_instance.defects.find(params[:id])
        end

        def defects
          @defects ||= phase_instance.defects.includes(:phase_injected).all
        end

        def phase_instance
          @phase_instance ||= PhaseInstance.find(params[:phase_instance_id])
        end
      end
    end
  end
end
