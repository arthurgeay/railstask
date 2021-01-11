class Project < ApplicationRecord
    validates :name, :description, :color, presence: true
    has_many :task_lists, dependent: :destroy
    has_many :project_users, dependent: :destroy
    has_many :users, through: :project_users
    accepts_nested_attributes_for :project_users
end
