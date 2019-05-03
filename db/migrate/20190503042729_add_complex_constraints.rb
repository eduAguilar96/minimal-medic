class AddComplexConstraints < ActiveRecord::Migration[5.2]
  def up

    # Unlimited insurance plan allow patients to be treated by doctors in any
    # area of the hospital.
    # Premium insurance allows patients to receive treatments for all areas
    # except Radiology.
    # Basic Insurance covers only General Medicine, Obstetrics and Pediatrics
    execute <<-SQL
      CREATE OR REPLACE FUNCTION get_patient_insurance(patient_id uuid)
        RETURNS int
      AS
      $BODY$
      DECLARE
        patient_insurance integer;
      BEGIN
        SELECT "insurancePlan"
          INTO patient_insurance
        FROM patients p
        WHERE p."id" = patient_id;
        RETURN patient_insurance;
      END;
      $BODY$ LANGUAGE plpgsql;

      CREATE OR REPLACE FUNCTION get_doctor_specialty(doctor_id uuid)
        RETURNS int
      AS
      $BODY$
      DECLARE
        doctor_specialty integer;
      BEGIN
        SELECT "specialty"
          INTO doctor_specialty
        FROM doctors d
        WHERE d."id" = doctor_id;
        RETURN doctor_specialty;
      END;
      $BODY$ LANGUAGE plpgsql;

      ALTER TABLE treatments
        ADD CONSTRAINT check_insurance
        CHECK(
          get_patient_insurance("patient_id") = 0 AND get_doctor_specialty("doctor_id") = 0 OR
          get_patient_insurance("patient_id") = 0 AND get_doctor_specialty("doctor_id") = 6 OR
          get_patient_insurance("patient_id") = 0 AND get_doctor_specialty("doctor_id") = 7 OR
          get_patient_insurance("patient_id") = 1 AND get_doctor_specialty("doctor_id") != 3 OR
          get_patient_insurance("patient_id") = 2
        );
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE treatments DROP CONSTRAINT check_insurance;
      DROP FUNCTION IF EXISTS get_patient_insurance;
      DROP FUNCTION IF EXISTS get_doctor_specialty;
    SQL
  end
end
