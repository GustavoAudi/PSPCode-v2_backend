class AddDeviseTokenAuthFieldsProfessors < ActiveRecord::Migration[5.0]
  def change
    add_column :professors, :provider, :string, null: false, default: 'email'
    add_column :professors, :uid, :string, null: false, default: ''
    add_column :professors, :tokens, :json

    add_index :professors, %i[uid provider], unique: true
  end
end
