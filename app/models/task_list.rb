class TaskList < ApplicationRecord
    has_many :tasks
    belongs_to :project

    validates :name, presence: true
end
