if @resource.is_a? User
  json.partial! 'api/v1/users/info', user: @resource
else
  json.partial! 'api/v1/professors/info', professor: @resource
end
