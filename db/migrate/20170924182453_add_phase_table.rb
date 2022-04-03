# frozen_string_literal: true

class AddPhaseTable < ActiveRecord::Migration[5.1]
  def change
    create_table :phases do |t|
      t.string :name, null: false
      t.string :description
    end
  end
end
