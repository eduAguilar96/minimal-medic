class Doctor < ApplicationRecord
  has_one :person, as: :labor
  accepts_nested_attributes_for :person
  has_many :treatments
  belongs_to :domain, :class_name => 'Area', :optional => true
  belongs_to :area, :class_name => 'Area'
end
