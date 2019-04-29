class Patient < ApplicationRecord
  has_one :person, as: :labor
  accepts_nested_attributes_for :person
  has_many :treatments

  def insurance(num)
    arr = ["Basic",
    "Premium",
    "Unlimited"]
    arr[num]
  end
end
