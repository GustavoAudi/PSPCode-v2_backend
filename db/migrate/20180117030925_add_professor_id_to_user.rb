class AddProfessorIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :professor
  end
end
