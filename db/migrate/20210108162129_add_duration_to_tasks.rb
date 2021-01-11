class AddDurationToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :duration, :string
  end
end
