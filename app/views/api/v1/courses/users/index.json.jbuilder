# frozen_string_literal: true

json.array! @users do |user|
  json.partial! 'api/v1/courses/users/info', user:
end
