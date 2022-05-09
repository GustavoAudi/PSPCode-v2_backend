json.array! @phase_instances do |phase_instance|
  json.partial! 'api/v1/phase_instances/info', phase_instance:
end
