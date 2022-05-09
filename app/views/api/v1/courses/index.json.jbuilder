json.array! @courses do |course|
  json.partial! 'api/v1/courses/info', course:
end
