# frozen_string_literal: true

module Exceptions
  class BaseException < StandardError
    attr_reader :parameter

    def initialize(parameter)
      super
      @parameter = parameter
    end
  end

  class ParameterInvalid < BaseException
  end

  class AuthorizationException < BaseException
  end
end
