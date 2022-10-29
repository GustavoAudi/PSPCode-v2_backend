# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_16_011830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assigned_projects", force: :cascade do |t|
    t.bigint "course_project_instance_id", null: false
    t.bigint "user_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "process_id"
    t.index ["course_project_instance_id"], name: "index_assigned_projects_on_course_project_instance_id"
    t.index ["process_id"], name: "index_assigned_projects_on_process_id"
    t.index ["user_id"], name: "index_assigned_projects_on_user_id"
  end

  create_table "corrections", force: :cascade do |t|
    t.boolean "approved", default: false
    t.string "comment"
    t.bigint "criterion_id", null: false
    t.bigint "project_feedback_id", null: false
    t.index ["criterion_id"], name: "index_corrections_on_criterion_id"
    t.index ["project_feedback_id"], name: "index_corrections_on_project_feedback_id"
  end

  create_table "course_project_instances", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "course_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "assigned_count", default: 0
    t.integer "working_count", default: 0
    t.integer "being_corrected_count", default: 0
    t.integer "approved_count", default: 0
    t.integer "need_correction_count", default: 0
    t.integer "assigned_projects_count", default: 0
    t.index ["course_id"], name: "index_course_project_instances_on_course_id"
    t.index ["end_date"], name: "index_course_project_instances_on_end_date"
    t.index ["project_id"], name: "index_course_project_instances_on_project_id"
  end

  create_table "courses", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.string "description"
    t.string "additional_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
  end

  create_table "criteria", force: :cascade do |t|
    t.string "description", null: false
    t.boolean "only_in_psp01", default: false
    t.bigint "section_id", null: false
    t.integer "order", null: false
    t.integer "algorithm", default: 0, null: false
    t.index ["section_id"], name: "index_criteria_on_section_id"
  end

  create_table "defects", force: :cascade do |t|
    t.datetime "discovered_time", null: false
    t.bigint "phase_injected_id", null: false
    t.bigint "phase_instance_id", null: false
    t.integer "defect_type", null: false
    t.integer "fix_defect"
    t.datetime "fixed_time", null: false
    t.string "description", null: false
    t.index ["phase_injected_id"], name: "index_defects_on_phase_injected_id"
    t.index ["phase_instance_id"], name: "index_defects_on_phase_instance_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "event_notifications", force: :cascade do |t|
    t.bigint "assigned_project_id", null: false
    t.string "originator_type", null: false
    t.integer "originator_id", null: false
    t.string "receiver_type", null: false
    t.integer "receiver_id", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_delivery_id"
    t.index ["assigned_project_id"], name: "index_event_notifications_on_assigned_project_id"
    t.index ["project_delivery_id"], name: "index_event_notifications_on_project_delivery_id"
  end

  create_table "message_notifications", force: :cascade do |t|
    t.bigint "assigned_project_id", null: false
    t.string "originator_type", null: false
    t.integer "originator_id", null: false
    t.string "receiver_type", null: false
    t.integer "receiver_id", null: false
    t.bigint "message_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_project_id"], name: "index_message_notifications_on_assigned_project_id"
    t.index ["message_id"], name: "index_message_notifications_on_message_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "text"
    t.integer "sender_id", null: false
    t.string "sender_type", null: false
    t.bigint "assigned_project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file"
    t.integer "message_type", default: 0
    t.index ["assigned_project_id"], name: "index_messages_on_assigned_project_id"
  end

  create_table "phase_instances", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "phase_id"
    t.bigint "project_delivery_id", null: false
    t.integer "interruption_time", default: 0
    t.integer "plan_time", default: 0
    t.integer "plan_loc", default: 0
    t.integer "actual_base_loc", default: 0
    t.integer "modified", default: 0
    t.integer "deleted", default: 0
    t.integer "reused", default: 0
    t.integer "new_reusable", default: 0
    t.integer "total", default: 0
    t.string "pip_problem", default: ""
    t.string "pip_proposal", default: ""
    t.string "pip_notes", default: ""
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "elapsed_time", default: 0
    t.boolean "first", default: false
    t.boolean "last", default: false
    t.index ["phase_id"], name: "index_phase_instances_on_phase_id"
    t.index ["project_delivery_id"], name: "index_phase_instances_on_project_delivery_id"
  end

  create_table "phase_time_summaries", force: :cascade do |t|
    t.integer "actual", default: 0
    t.bigint "phase_id", null: false
    t.bigint "project_delivery_id", null: false
    t.integer "previous_phase_time"
    t.integer "to_date"
    t.integer "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phase_id"], name: "index_phase_time_summaries_on_phase_id"
    t.index ["project_delivery_id"], name: "index_phase_time_summaries_on_project_delivery_id"
  end

  create_table "phases", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.integer "order"
    t.boolean "first", default: false
    t.boolean "last", default: false
  end

  create_table "professor_courses", force: :cascade do |t|
    t.bigint "professor_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_professor_courses_on_course_id"
    t.index ["professor_id"], name: "index_professor_courses_on_professor_id"
  end

  create_table "professors", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "additional_notes"
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.json "tokens"
    t.datetime "last_seen_event_notification"
    t.datetime "last_seen_message_notification"
    t.index ["email"], name: "index_professors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_professors_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_professors_on_uid_and_provider", unique: true
  end

  create_table "project_deliveries", force: :cascade do |t|
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "assigned_project_id", null: false
    t.integer "version_number", default: 1
    t.index ["assigned_project_id"], name: "index_project_deliveries_on_assigned_project_id"
  end

  create_table "project_feedbacks", force: :cascade do |t|
    t.string "comment"
    t.boolean "approved", default: false
    t.date "delivered_date", null: false
    t.date "reviewed_date"
    t.bigint "project_delivery_id", null: false
    t.index ["project_delivery_id"], name: "index_project_feedbacks_on_project_delivery_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "process_id", null: false
    t.string "description_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["process_id"], name: "index_projects_on_process_id"
  end

  create_table "psp_process_phases", force: :cascade do |t|
    t.bigint "phase_id"
    t.bigint "psp_process_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phase_id"], name: "index_psp_process_phases_on_phase_id"
    t.index ["psp_process_id"], name: "index_psp_process_phases_on_psp_process_id"
  end

  create_table "psp_processes", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_plan_time", default: false
    t.boolean "has_plan_loc", default: false
    t.boolean "has_pip", default: false
  end

  create_table "sections", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.bigint "assigned_project_id", null: false
    t.bigint "user_id", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_delivery_id"
    t.index ["assigned_project_id"], name: "index_statuses_on_assigned_project_id"
    t.index ["project_delivery_id"], name: "index_statuses_on_project_delivery_id"
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.boolean "allow_password_change", default: false, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name", default: ""
    t.string "last_name", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.json "tokens"
    t.text "approved_subjects", default: [], array: true
    t.string "programming_language"
    t.boolean "have_a_job"
    t.string "job_role"
    t.string "academic_experience"
    t.string "programming_experience"
    t.string "collegue_career_progress"
    t.integer "course_id", null: false
    t.bigint "professor_id"
    t.bigint "current_assigned_project_id"
    t.datetime "last_seen_event_notification"
    t.datetime "last_seen_message_notification"
    t.index ["course_id"], name: "index_users_on_course_id"
    t.index ["current_assigned_project_id"], name: "index_users_on_current_assigned_project_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["professor_id"], name: "index_users_on_professor_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

end
