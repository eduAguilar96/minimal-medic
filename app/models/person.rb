class Person < ApplicationRecord
  belongs_to :labor, polymorphic: true
end
