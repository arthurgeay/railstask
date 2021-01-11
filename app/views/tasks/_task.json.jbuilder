json.extract! task, :id, :title, :duration, :status, :description, :task_list_id, :users, :created_at, :updated_at
json.url project_task_list_task_url(task, format: :json)
