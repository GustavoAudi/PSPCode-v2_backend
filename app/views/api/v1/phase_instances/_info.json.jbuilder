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

if @professor_authenticated.present? ## Observations for professor
  json.observations do
    json.elapsed_time phase_instance.build_elapsed_time_obs
    json.fix_time phase_instance.build_fix_time_obs
    json.break_time phase_instance.build_break_time_obs
    json.plan_time phase_instance.build_plan_time_obs
    json.empty_loc phase_instance.build_empty_loc_obs
    json.empty_total phase_instance.build_empty_total_obs
  end
end
