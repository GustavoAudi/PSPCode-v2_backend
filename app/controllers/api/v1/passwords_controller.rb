# frozen_string_literal: true

module Api
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      protect_from_forgery with: :exception
      include Concerns::ActAsApiRequest
      skip_before_action :check_json_request, on: :edit
    end
  end
end
