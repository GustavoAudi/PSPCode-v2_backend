# frozen_string_literal: true

class RemoveMandatoryTextForMessages < ActiveRecord::Migration[5.1]
  def change
    change_column :messages, :text, :string, null: true
  end
end
