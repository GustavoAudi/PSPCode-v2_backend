# frozen_string_literal: true

require 'rails_helper'

describe 'POST api/v1/users/sign_in', type: :request do
  context 'for students' do
    let(:password) { 'password' }
    let(:user) { create(:user, password: password) }

    context 'with correct params' do
      before do
        params = {
          user:
            {
              email: user.email,
              password: password
            }
        }
        post new_user_session_path, params: params, as: :json
      end

      # it 'returns success' do
      #   expect(response).to be_success
      # end

      # it 'returns the user' do
      #   expect(json[:id]).to eq(user.id)
      #   expect(json[:first_name]).to eq(user.first_name)
      #   expect(json[:last_name]).to eq(user.last_name)
      #   expect(json[:email]).to eq(user.email)
      #   expect(json[:role]).to eq('student')
      #   expect(json[:programming_language]).to eq(user.programming_language)
      #   expect(json[:course]).not_to be_nil
      # end

      # it 'returns a valid client and access token' do
      #   token = response.header['access-token']
      #   client = response.header['client']
      #   expect(user.reload.valid_token?(token, client)).to be_truthy
      # end
    end

    context 'with incorrect params' do
      it 'return errors upon failure' do
        params = {
          user: {
            email: user.email,
            password: 'wrong_password!'
          }
        }
        post new_user_session_path, params: params, as: :json

        expect(response).to be_unauthorized
        expected_response = {
          errors: ['Invalid login credentials. Please try again.'], "success" => false
        }.with_indifferent_access
        expect(json).to eq(expected_response)
      end
    end
  end

  context 'for professors' do
    let(:password) { 'password' }
    let(:professor) { create(:professor, password: password) }

    context 'with correct params' do
      before do
        params = {
          user:
            {
              email: professor.email,
              password: password
            }
        }
        post new_user_session_path, params: params, as: :json
      end

      it 'returns success' do
        expect(response).to be_success
      end

      it 'returns the user' do
        expect(json[:id]).to eq(professor.id)
        expect(json[:first_name]).to eq(professor.first_name)
        expect(json[:last_name]).to eq(professor.last_name)
        expect(json[:email]).to eq(professor.email)
        expect(json[:role]).to eq('professor')
      end

      it 'returns a valid client and access token' do
        token = response.header['access-token']
        client = response.header['client']
        expect(professor.reload.valid_token?(token, client)).to be_truthy
      end
    end

    context 'with incorrect params' do
      it 'return errors upon failure' do
        params = {
          user: {
            email: professor.email,
            password: 'wrong_password!'
          }
        }
        post new_user_session_path, params: params, as: :json

        expect(response).to be_unauthorized
        expected_response = {
          errors: ['Invalid login credentials. Please try again.'], "success" => false
        }.with_indifferent_access
        expect(json).to eq(expected_response)
      end
    end
  end
end
