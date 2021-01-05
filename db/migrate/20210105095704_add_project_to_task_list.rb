class AddProjectToTaskList < ActiveRecord::Migration[6.0]
  def change
    add_reference :task_lists, :project, null: false, foreign_key: true
  end
end
