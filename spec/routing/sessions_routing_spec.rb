# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SessionsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/users/sign_in').to route_to('api/v1/sessions#create')
    end

    it 'routes to #facebook' do
      expect(post: '/api/v1/user/facebook').to route_to('api/v1/sessions#facebook', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: 'api/v1/users/sign_out').to route_to('api/v1/sessions#destroy')
    end
  end
end
