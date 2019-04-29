class PatientController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  def index
    @patients = Patient.all
  end

  def show
    @patient
  end

  def create
    @patient = Patient.create!(patient_params)
  end

  def update
  end

  def destroy
  end

  private

    def set_patient
      @patient = Patient.find(params[:id])
    end

    def patient_params
      params.require(:patient).permit(
        :insurancePlan,
        person_attributes:[
          :firstName,
          :lastName,
          :dob,
          :gender
        ]
      )
    end
end
