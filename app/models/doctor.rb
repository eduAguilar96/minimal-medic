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

  # trigger.after(:update) do
  #   <<-SQL
  #     IF (NEW.years_experience - OLD.years_experience >= 2) THEN
  #       UPDATE doctors
  #         SET salary = 1.1*(SELECT salary FROM doctors WHERE id = OLD.id)
  #       WHERE id = OLD.id;
  #     END IF;
  #   SQL
  # end
  #
  # trigger.after(:update) do
  #   <<-SQL
  #     IF (NEW.area_id != OLD.area_id AND OLD.domain_id != NULL) THEN
  #       UPDATE doctors
  #         SET domain_id = OLD.domain_id
  #       WHERE id = (
  #         SELECT id
  #         FROM doctors
  #         WHERE area_id = OLD.domain_id LIMIT 1
  #       );
  #
  #       UPDATE doctors
  #         SET domain_id = NULL
  #       WHERE id = OLD.id;
  #     END IF;
  #   SQL
  # end
end
