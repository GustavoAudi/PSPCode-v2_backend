# frozen_string_literal: true

class AddTypeToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :type, :integer, default: 0
  end
end
