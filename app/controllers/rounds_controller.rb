class RoundsController < ApplicationController
  before_action :authenticate_user!

  def index
    @system = System.find(params[:system_id])
    @rounds = @system.rounds
    if @rounds.empty?
      redirect_to new_round_path(:system_id => @system.id)
    elsif @rounds.last.finalized?
      redirect_to new_round_path(:system_id => @system.id)
    else
      redirect_to @rounds.last
    end
  end

  def new
    @system = System.find(params[:system_id])
    @pairings = get_initial_pairings(@system.registrants)
    @round = Round.new(:round => @system.rounds.count, :finalized => false)
  end

  def create

  end

  def show

  end

  def get_initial_pairings(registrants)
    registrants.in_groups_of(2, Registrant.new(:user_id => 1))
  end

  def rounds_params
    params.require(:round).permit(:round, :finalized, :system_id)
  end
end
