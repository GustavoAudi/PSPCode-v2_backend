# frozen_string_literal: true

class AddFileToMessage < ActiveRecord::Migration[5.1]
  def change
    rename_column :messages, :link, :file
  end
end
