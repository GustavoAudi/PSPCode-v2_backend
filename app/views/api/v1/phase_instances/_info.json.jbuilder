# frozen_string_literal: true

json.id phase_instance.id
json.psp_phase do
  json.partial! 'api/v1/phases/info', phase: phase_instance.phase if phase_instance.phase.present?
end
json.start_time phase_instance.start_time
json.end_time phase_instance.end_time
json.interruption_time phase_instance.interruption_time
json.comments phase_instance.comments
json.plan_loc phase_instance.plan_loc
json.actual_base_loc phase_instance.actual_base_loc
json.plan_time phase_instance.plan_time
json.modified phase_instance.modified
json.deleted phase_instance.deleted
json.reused phase_instance.reused
json.new_reusable phase_instance.new_reusable
json.total phase_instance.total
json.pip_problem phase_instance.pip_problem
json.pip_proposal phase_instance.pip_proposal
json.pip_notes phase_instance.pip_notes

if @is_professor_authenticated ## Observations for professor
  json.observations do
    json.total_time phase_instance.get_total_time_obs
    json.defect_fix_times phase_instance.get_defect_fix_times_obs
  end
end