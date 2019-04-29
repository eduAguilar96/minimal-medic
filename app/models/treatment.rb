class Treatment < ApplicationRecord
  belongs_to :Patient
  belongs_to :Doctor
end
