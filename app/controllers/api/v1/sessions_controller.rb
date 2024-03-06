# frozen_string_literal: true

module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      protect_from_forgery with: :null_session
      include Concerns::ActAsApiRequest

      # Rubocop disabled since the method is extracted from the gem to monkeypatch authentication
      # for both user and professor
      # rubocop:disable all
      def create
        # Check

        field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

        @resource = nil
        if field
          q_value = resource_params[field]

          redefined_resource_class = if Professor.find_by({ "#{field}": q_value })
                                       Professor
                                     else
                                       resource_class
                                     end

          if resource_class.case_insensitive_keys.include?(field)
            q_value.downcase!
          end

          q = "#{field.to_s} = ? AND provider='email'"

          if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
            q = "BINARY " + q
          end

          @resource = redefined_resource_class.where(q, q_value).first
        end

        if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
          valid_password = @resource.valid_password?(resource_params[:password])
          if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
            return render_create_error_bad_credentials
          end
          @token = @resource.create_token
          @resource.save

          sign_in(:user, @resource, store: false, bypass: false)

          yield @resource if block_given?

        elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
          render_create_error_not_confirmed
        else
          render_create_error_bad_credentials
        end
      end

      def resource_params
        params.require(:user).permit(:email, :password)
      end

      private

      # user auth
      def set_user_by_token(mapping=nil)
        # determine target authentication class
        rc = resource_class(mapping)

        # Load Alternative resource_class to contemplate both models
        alt_rc = rc == User ? Professor : User

        # no default user defined
        return unless rc || alt_rc

        #gets the headers names, which was set in the initialize file
        uid_name = DeviseTokenAuth.headers_names[:'uid']
        access_token_name = DeviseTokenAuth.headers_names[:'access-token']
        client_name = DeviseTokenAuth.headers_names[:'client']

        # parse header for values necessary for authentication
        uid        = request.headers[uid_name] || params[uid_name]
        @token           = DeviseTokenAuth::TokenFactory.new unless @token
        @token.token     ||= request.headers[access_token_name] || params[access_token_name]
        @token.client ||= request.headers[client_name] || params[client_name]

        # client_id isn't required, set to 'default' if absent
        @token.client ||= 'default'

        # check for an existing user, authenticated via warden/devise, if enabled
        if DeviseTokenAuth.enable_standard_devise_support
          devise_warden_user = warden.user(rc.to_s.underscore.to_sym)
          devise_warden_user = warden.user(alt_rc.to_s.underscore.to_sym) if devise_warden_user.blank?
          if devise_warden_user && devise_warden_user.tokens[@token.client].nil?
            @used_auth_by_token = false
            @resource = devise_warden_user
          end
        end

        # user has already been found and authenticated
        return @resource if @resource && (@resource.class == rc || @resource.class == alt_rc)

        # ensure we clear the client
        unless @token.present?
          @token.client = nil
          return
        end

        # mitigate timing attacks by finding by uid instead of auth token
        user = uid && (rc.find_by(uid: uid) || alt_rc.find_by(uid: uid))

        if user && user.valid_token?(@token.token, @token.client)
          # sign_in with bypass: true will be deprecated in the next version of Devise
          if self.respond_to? :bypass_sign_in
            bypass_sign_in(user, scope: :user)
          else
            sign_in(:user, user, store: false, event: :fetch, bypass: DeviseTokenAuth.bypass_sign_in)
          end
          @resource = user
        else
          # zero all values previously set values
          @token.client = nil
          @resource = nil
        end
      end

      def json_request?
        request.format.json?
      end
    end
  end
end
