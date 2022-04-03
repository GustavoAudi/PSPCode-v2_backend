# frozen_string_literal: true

class AddVersionNumberToProjectDelivery < ActiveRecord::Migration[5.1]
  def change
    add_column :project_deliveries, :version_number, :integer, default: 1
  end
end
