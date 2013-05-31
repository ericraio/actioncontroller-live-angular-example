class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  # GET /games/:slug
  def show
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game ||= Game.where(slug: params[:slug]).first
  end

end
