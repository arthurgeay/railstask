class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.date :date_start
      t.date :date_end
      t.string :status
      t.string :description
      t.references :user,null:false,foreign_key:true
      t.references :project,null:false,foreign_key:true
      t.references :task_list,null:false,foreign_key:true

      t.timestamps
    end
  end
end
