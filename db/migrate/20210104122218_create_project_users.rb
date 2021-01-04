class CreateProjectUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :project_users do |t|
      t.references :users
      t.string :role
      t.references :projects
      t.timestamps
    end
  end
end
