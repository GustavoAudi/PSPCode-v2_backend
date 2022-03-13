json.id defect.id
json.phase_injected do
  json.id defect.phase_injected_id
  json.psp_phase do
    json.partial! 'api/v1/phases/info', phase: defect.phase_injected
  end
end
json.defect_type defect.defect_type
json.discovered_time defect.discovered_time
json.fixed_time defect.fixed_time
json.description defect.description
json.fix_defect defect.fix_defect
