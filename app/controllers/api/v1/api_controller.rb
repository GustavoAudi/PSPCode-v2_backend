# encoding: utf-8

module Api
  module V1
    class ApiController < ApplicationController
      include Concerns::ActAsApiRequest
      include DeviseTokenAuth::Concerns::SetUserByToken

      layout false
      respond_to :json

      rescue_from Exception,                           with: :render_error
      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
      rescue_from ActionController::RoutingError,      with: :render_not_found
      rescue_from ActionController::UnknownFormat, with: :render_not_found
      rescue_from AbstractController::ActionNotFound,  with: :render_not_found
      rescue_from Exceptions::AuthorizationException,  with: :unauthorized_exception

      def status
        render json: { online: true }
      end

      def unauthorized_exception(exception)
        render json:
          { errors: "Unauthorized access to profile of user with id '#{exception.parameter}'" },
               status: :unauthorized
      end

      def render_error(exception)
        logger.error(exception) # Report to your error managment tool here
        Rollbar.error(exception)
        render json: { error: 'An error ocurred' }, status: 500 unless performed?
      end

      def render_not_found(exception)
        logger.info(exception) # for logging
        Rollbar.warning(exception)
        render json: { error: "Couldn't find the record" }, status: :not_found
      end

      def render_record_invalid(exception)
        logger.info(exception) # for logging
        render json: { errors: exception.record.errors.as_json }, status: :bad_request
      end
    end
  end
end
