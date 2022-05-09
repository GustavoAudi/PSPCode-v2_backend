json.id project.id
json.instructions project.description_file.url
json.process do
  json.partial! 'api/v1/psp_processes/info', process: project.process
end
