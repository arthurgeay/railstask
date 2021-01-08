class Task < ApplicationRecord
    validates :title, :date_start, :date_end, :status, :description, :user_id, presence: true
    belongs_to :task_list
end
