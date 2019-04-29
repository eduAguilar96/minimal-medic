class CreatePersons < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'uuid-ossp'

    create_table :areas do |t|
      t.string :name, :null => false
      t.string :location, :null => false
      t.integer :speciality, :null => false

      t.timestamps
    end

    create_table :people, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string :firstName, :null => false
      t.string :lastName
      t.string :dob
      t.string :gender, :null => false
      t.references :labor, polymorphic: true, index: true, :null => false
      t.timestamps
    end

    create_table :doctors, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.integer :specialty, :null => false
      t.integer :yearsExperience, :null => false
      t.decimal :salary, :null => false, :precision => 64, :scale => 12 
      t.uuid :areaWork
      t.uuid :areaLead
      t.timestamps
    end

    create_table :patients, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.integer :insurancePlan, :null => false
      t.timestamps
    end

    create_table :treatments, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.belongs_to :patient, index: true, :null => false
      t.belongs_to :doctor, index: true, :null => false
      t.integer :duration
      t.text :medicaments, array: true, default: []
      t.string :description

      t.timestamps
    end

  end
end
