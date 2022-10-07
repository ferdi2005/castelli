class CastlesController < ApplicationController
  def index
    @castles = Castle.where.not(latitude: nil, longitude: nil)
  end

  def show
    @castle = Castle.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @monument }
    end
  end
end
