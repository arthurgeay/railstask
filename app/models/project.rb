class Project < ApplicationRecord
    validates :name, :description, :color, presence: true
    has_many :task_lists
    has_many :project_users
    accepts_nested_attributes_for :project_users
end
