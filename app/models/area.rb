class Area < ApplicationRecord
  has_one :leader, :class_name => 'Doctor', :foreign_key => 'domain_id'
  has_many :doctors, :class_name => 'Doctor', :foreign_key => 'area_id'
end
