# frozen_string_literal: true

json.processes @processes.each do |process|
  json.process do
    json.partial! 'api/v1/psp_processes/info', process: process
    json.phases process.phases.each do |phase|
      json.partial! 'api/v1/phases/info', phase: phase
    end
  end
end
