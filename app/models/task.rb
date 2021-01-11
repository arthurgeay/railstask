class Task < ApplicationRecord
    validates :title, :duration, :status, :description, presence: true
    validates_associated :task_users
    belongs_to :task_list
    has_many :task_users, dependent: :destroy
    has_many :users, through: :task_users
    accepts_nested_attributes_for :task_users
end
