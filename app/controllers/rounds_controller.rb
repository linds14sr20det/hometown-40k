class RoundsController < ApplicationController
  before_action :authenticate_user!

  def index
    @system = System.find(params[:system_id])
    @rounds = @system.rounds
    if @rounds.empty?
      redirect_to new_round_path(:system_id => @system.id)
    elsif @rounds.last.complete?
      redirect_to new_round_path(:system_id => @system.id)
    else
      redirect_to @rounds.last
    end
  end

  def new
    @system = System.find(params[:system_id])
    redirect_to @system.rounds.last unless @system.rounds.empty? || @system.rounds.last.complete? || @system.rounds.count < @system.round_count
    @round = @system.rounds.new(:round => @system.rounds.count, :complete => false)
    set_initial_pairings(@system.registrants)
  end

  def create
    @round = Round.create(rounds_params)
    @round.update(:complete => false)
    redirect_to @round
  end

  def show
    @round = Round.find(params[:id])
  end

  def complete_round
    # TODO: Create or update aggregates
    @round.update(complete: true)
    redirect_to new

    # # Set outcomes of the last round
    # round = params[:id].to_i
    # pairings = RoundIndividual.where(round: round, system_id: params[:system_id])
    # round_aggregates = RoundAggregate.where(system_id: params[:system_id])
    # pairings.each do |pairing|
    #   para = round_aggregates.find_by(player_id: pairing.player_a.id)
    #   parb = round_aggregates.find_by(player_id: pairing.player_b.id)
    #   player_a = {win: 0, draw: 0, loss: 0}
    #   player_b = {win: 0, draw: 0, loss: 0}
    #   differential = pairing.player_a_points - pairing.player_b_points
    #   if differential > 0
    #     player_a[:win] = 1
    #     player_b[:loss] = 1
    #   elsif differential < 0
    #     player_a[:loss] = 1
    #     player_b[:win] = 1
    #   elsif differential == 0
    #     player_a[:draw] = 1
    #     player_b[:draw] = 1
    #   end
    #   para.update_attributes(
    #     total_points: para.total_points + pairing.player_a_points + (player_a[:win] * 1000) + (player_a[:draw] * 500),
    #     wins: para.wins + player_a[:win],
    #     draws: para.draws + player_a[:draw],
    #     losses: para.losses + player_a[:loss],
    #     opponents: para.opponents << pairing.player_b.id,
    #     )
    #   parb.update_attributes(
    #     total_points: parb.total_points + pairing.player_b_points + (player_b[:win] * 1000) + (player_b[:draw] * 500),
    #     wins: parb.wins + player_b[:win],
    #     draws: parb.draws + player_b[:draw],
    #     losses: parb.losses + player_b[:loss],
    #     opponents: parb.opponents << pairing.player_a.id,
    #     )
    # end
    #
    # # TODO: Increment the round number so you can't mess up previous rounds
    #
    # # Setup the next round
    # round_aggregates = RoundAggregate.where(system: params[:system_id]).order(total_points: :desc)
    # # TODO: Sort pairings to avoid prior played opponents
    # new_pairings = round_aggregates.in_groups_of(2, RoundAggregate.new(player_id: 1, system_id: params[:system_id]))
    # new_pairings.each do |pairing|
    #   RoundIndividual.create(player_a: pairing[0].player, player_b: pairing[1].player, system: pairing[0].system, round: round + 1)
    # end
    # redirect_to round_individual_path(id: round + 1, system_id: params[:system_id])
  end

  private

  def set_initial_pairings(registrants)
    # TODO: This needs to be based on the previous round
    pairings = registrants.in_groups_of(2, Registrant.new(:user_id => 1))
    pairings.each do |pairing|
      @round.round_individuals.new(player_a_id: pairing[0].user.id, player_b_id: pairing[1].user.id)
    end
  end

  def rounds_params
    params.require(:round).permit(:round, :finalized, :system_id, round_individuals_attributes: [:player_a_id, :player_b_id])
  end
end
