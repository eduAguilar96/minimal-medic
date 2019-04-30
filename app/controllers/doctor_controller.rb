class DoctorController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_doctor, only: [:show, :edit, :update, :destroy]
  def index
    @doctors = Doctor.all
  end

  def show
    @doctor
  end

  def create
    @doctor = Doctor.create!(doctor_params)
  end

  def update
  end

  def destroy
  end

  private

    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    def doctor_params
      params.require(:doctor)
    end
end
