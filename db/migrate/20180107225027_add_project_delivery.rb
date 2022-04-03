# frozen_string_literal: true

class AddProjectDelivery < ActiveRecord::Migration[5.1]
  def change
    create_table :project_deliveries do |t|
      t.string :file
      t.timestamps
    end
  end
end
