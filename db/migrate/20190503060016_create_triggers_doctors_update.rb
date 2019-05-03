# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersDoctorsUpdate < ActiveRecord::Migration[5.2]
  def up
    create_trigger("doctors_after_update_row_a", :generated => true, :compatibility => 1).
        on("doctors").
        after(:update) do
      <<-SQL_ACTIONS
      IF (NEW.years_experience - OLD.years_experience >= 2) THEN
        UPDATE doctors
          SET salary = 1.1*(SELECT salary FROM doctors WHERE id = OLD.id)
        WHERE id = OLD.id;
      END IF;
      SQL_ACTIONS
    end

    create_trigger("doctors_after_update_row_b", :generated => true, :compatibility => 1).
        on("doctors").
        after(:update) do
      <<-SQL_ACTIONS
      IF (NEW.area_id != OLD.area_id AND OLD.domain_id != NULL) THEN
        UPDATE doctors
          SET domain_id = OLD.domain_id
        WHERE id = (
          SELECT id
          FROM doctors
          WHERE area_id = OLD.domain_id LIMIT 1
        );

        UPDATE doctors
          SET domain_id = NULL
        WHERE id = OLD.id;
      END IF;
      SQL_ACTIONS
    end
  end

  def down
    drop_trigger("doctors_after_update_row_a", "doctors", :generated => true)
    drop_trigger("doctors_after_update_row_b", "doctors", :generated => true)
  end
end
