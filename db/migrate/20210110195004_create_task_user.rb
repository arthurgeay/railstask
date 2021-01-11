class CreateTaskUser < ActiveRecord::Migration[6.0]
  def change
    create_table :task_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
    end
  end
end
