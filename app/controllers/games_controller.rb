class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  # GET /game/:title
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game ||= Game.where(url: params[:title]).first
    end

    # Only allow a trusted parameter "white list" through.
    def game_params
      params.require(:game).permit(:show)
    end
end
