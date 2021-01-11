class RemoveDatesFromTasks < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :date_start, :date
    remove_column :tasks, :date_end, :date
  end
end
