class Task < ApplicationRecord
    validates :title, :duration, :status, :description, :user_id, presence: true
    belongs_to :task_list
end
