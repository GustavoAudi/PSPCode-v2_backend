class AddHasPlanHasPipHasLocToProcess < ActiveRecord::Migration[5.1]
  def change
    add_column :psp_processes, :has_plan_time, :boolean, default: false
    add_column :psp_processes, :has_plan_loc, :boolean, default: false
    add_column :psp_processes, :has_pip, :boolean, default: false
  end
end
