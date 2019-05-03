class Doctor < ApplicationRecord
  has_one :person, as: :labor
  accepts_nested_attributes_for :person
  has_many :treatments
  belongs_to :domain, :class_name => 'Area', :optional => true
  belongs_to :area, :class_name => 'Area'

  def specialtyName(num)
    arr = [
      "General Medicine",
      "Traumatology",
      "Allergology",
      "Radiology",
      "Cardiology",
      "Gerotology",
      "Obstetrics",
      "Pedriatics"
    ]
    arr[num]
  end
end
