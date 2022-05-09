json.array! @assigned_projects do |assigned_project|
  json.partial! 'api/v1/assigned_projects/info', assigned_project:
end
