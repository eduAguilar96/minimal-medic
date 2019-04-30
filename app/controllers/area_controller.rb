class AreaController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_area, only: [:show, :edit, :update, :destroy]
  def index
    @areas = Area.all
  end

  def show
    @area
  end

  def create
    @area = Area.create!(area_params)
  end

  def update
  end

  def destroy
  end

  private

    def set_area
      @area = Area.find(params[:id])
    end

    def area_params
      params.require(:area)
    end
end
