class RoundIndividualsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @pairing = RoundIndividual.find(params[:id])
  end

  def update
    pairing = RoundIndividual.find(params[:id])
    pairing.update_attributes(round_individual_params)
    redirect_to pairing.round
  end

  private

  def round_individual_params
    params.require(:round_individual).permit(:player_a_points, :player_b_points)
  end
end
