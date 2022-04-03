# frozen_string_literal: true

class AddValueToStatus < ActiveRecord::Migration[5.1]
  def change
    add_column :statuses, :value, :string, null: false
    add_column :statuses, :created_at, :datetime, null: false
    add_column :statuses, :updated_at, :datetime, null: false
  end
end
