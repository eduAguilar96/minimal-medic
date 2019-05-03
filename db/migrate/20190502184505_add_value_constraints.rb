class AddValueConstraints < ActiveRecord::Migration[5.2]
  def up
    # A doctor can be leader only of the Area he/she works on.
    execute <<-SQL
      ALTER TABLE doctors
        ADD CONSTRAINT check_leader_area
        CHECK ("area_id" = "domain_id" OR "domain_id" = NULL);
    SQL

    # Possible values for insurance plan are: Unlimited, Premium, Basic
    execute <<-SQL
      ALTER TABLE patients
        ADD CONSTRAINT check_plan
        CHECK ("insurancePlan" = 0 OR "insurancePlan" = 1 OR "insurancePlan" = 2);
    SQL

    # Medical Specialties for doctors and Hospital Areas share the same names
    # and these are limited to the following: General Medicine, Traumatology,
    # Allergology, Radiology, Cardiology, Gerontology, Obstetrics and
    # Pediatrics.
    execute <<-SQL
      ALTER TABLE doctors
        ADD CONSTRAINT check_specialty
        CHECK ("specialty" = 0 OR "specialty" = 1 OR "specialty" = 2 OR "specialty" = 3 OR "specialty" = 4 OR "specialty" = 5 OR "specialty" = 6 OR "specialty" = 7);

      ALTER TABLE areas
        ADD CONSTRAINT check_specialty
        CHECK ("specialty" = 0 OR "specialty" = 1 OR "specialty" = 2 OR "specialty" = 3 OR "specialty" = 4 OR "specialty" = 5 OR "specialty" = 6 OR "specialty" = 7);
    SQL

    # A doctor may be associated only to hospital areas that are part of his-
    # her specialties.
    execute <<-SQL
      CREATE OR REPLACE FUNCTION get_area_specialty(area_id uuid)
        RETURNS int
      AS
      $BODY$
      DECLARE
        area_specialty integer;
      BEGIN
        SELECT "specialty"
          INTO area_specialty
        FROM areas a
        WHERE a."id" = area_id;
        RETURN area_specialty;
      END;
      $BODY$ LANGUAGE plpgsql;

      ALTER TABLE doctors
        ADD CONSTRAINT check_specialty_area
        CHECK ("specialty" = get_area_specialty("area_id") OR "area_id" = NULL);
    SQL

    execute <<-SQL

    SQL

  end
  def down
    execute <<-SQL
      ALTER TABLE doctors DROP CONSTRAINT check_leader_area;
      ALTER TABLE patients DROP CONSTRAINT check_plan;
      ALTER TABLE doctors DROP CONSTRAINT check_specialty;;
      ALTER TABLE areas DROP CONSTRAINT check_specialty;
      ALTER TABLE doctors DROP CONSTRAINT check_specialty_area;
      DROP FUNCTION IF EXISTS get_area_specialty
    SQL
  end

end
