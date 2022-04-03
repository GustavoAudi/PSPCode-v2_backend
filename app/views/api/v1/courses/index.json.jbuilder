# frozen_string_literal: true

json.array! @courses do |course|
  json.partial! 'api/v1/courses/info', course:
end
