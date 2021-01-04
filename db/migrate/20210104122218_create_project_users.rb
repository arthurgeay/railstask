class CreateProjectUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :project_users do |t|
      t.references :user
      t.string :role
      t.references :project
      t.timestamps
    end
  end
end
