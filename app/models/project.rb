class Project < ApplicationRecord
    validates :name, :description, :color, presence: true
    #accepts_nested_attributes_for :
end
