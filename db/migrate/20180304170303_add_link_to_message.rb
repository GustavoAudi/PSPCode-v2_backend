# frozen_string_literal: true

class AddLinkToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :link, :string
  end
end
