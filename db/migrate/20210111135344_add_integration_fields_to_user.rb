class AddIntegrationFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :slack_webhook, :text, null:true
    add_column :users, :discord_webhook, :text, null:true
  end
end
