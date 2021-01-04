class Project < ApplicationRecord
    validates :name, :description, :color, presence: true
end
