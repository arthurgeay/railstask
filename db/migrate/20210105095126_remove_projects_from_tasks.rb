class RemoveProjectsFromTasks < ActiveRecord::Migration[6.0]
  def change
    remove_reference :tasks, :project, null: false, foreign_key: true
  end
end
