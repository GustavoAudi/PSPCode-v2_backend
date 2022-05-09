module Api
  module Concerns
    module ProfessorAuth
      extend ActiveSupport::Concern

      included do
        before_action :authenticate_professor!, except: :status
      end
    end
  end
end
