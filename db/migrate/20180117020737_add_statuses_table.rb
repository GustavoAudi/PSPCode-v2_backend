# frozen_string_literal: true

class AddStatusesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :statuses do |t|
      t.references :assigned_project, null: false
      t.references :user, null: false
    end
  end
end
