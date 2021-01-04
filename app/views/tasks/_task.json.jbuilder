json.extract! task, :id, :title, :date_start, :date_end, :status, :description, :user_id, :project_id, :task_list_id, :created_at, :updated_at
json.url task_url(task, format: :json)
