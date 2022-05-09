class AddAttrsToStudent < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :approved_subjects, :text, array: true, default: []
    add_column :users, :programming_lenguage, :string
    add_column :users, :have_a_job, :boolean
    add_column :users, :job_role, :string
    add_column :users, :academic_experience, :string
    add_column :users, :programming_experience, :string
    add_column :users, :collegue_career_progress, :string
    remove_column :users, :username, :string
  end
end
