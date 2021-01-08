class TaskList < ApplicationRecord
    validates :name, presence: true
    has_many :tasks
    belongs_to :project
end
