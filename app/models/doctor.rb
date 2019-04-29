class Doctor < ApplicationRecord
  has_one :person, as: :labor
  has_many :treatments
  accepts_nested_attributes_for :person
end
