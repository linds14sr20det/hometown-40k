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
    redirect_to @system.rounds.last unless @system.rounds.empty? || @system.rounds.last.complete? || @system.rounds.count < @system.round_individuals
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
    @round = Round.find(params[:id])
    set_aggregates
    @round.update(complete: true)
    redirect_to new_round_path(system_id: @round.system.id)
  end

  private

  def set_aggregates
    round_aggregates = RoundAggregate.where(system_id: @round.system.id)
    @round.round_individuals.each do |pairing|
      para = round_aggregates.find_by(player_id: pairing.player_a.id)
      parb = round_aggregates.find_by(player_id: pairing.player_b.id)
      player_a = {win: 0, draw: 0, loss: 0}
      player_b = {win: 0, draw: 0, loss: 0}
      if pairing.player_a_win?
        player_a[:win] = 1
        player_b[:loss] = 1
      elsif pairing.player_a_loss?
        player_a[:loss] = 1
        player_b[:win] = 1
      else
        player_a[:draw] = 1
        player_b[:draw] = 1
      end
      para.update_attributes(
        total_points: para.total_points + pairing.player_a_points + (player_a[:win] * 1000) + (player_a[:draw] * 500),
        wins: para.wins + player_a[:win],
        draws: para.draws + player_a[:draw],
        losses: para.losses + player_a[:loss],
        opponents: para.opponents << pairing.player_b.id,
        )
      parb.update_attributes(
        total_points: parb.total_points + pairing.player_b_points + (player_b[:win] * 1000) + (player_b[:draw] * 500),
        wins: parb.wins + player_b[:win],
        draws: parb.draws + player_b[:draw],
        losses: parb.losses + player_b[:loss],
        opponents: parb.opponents << pairing.player_a.id,
        )
    end
  end

  def set_initial_pairings(registrants)
    if @round.round == 0
      pairings = registrants.where(checked_in: true).map(&:user_id)
    else
      # TODO: This is where we can get fancy to avoid people who have already played having collisions.
      pairings = RoundAggregate.where(system_id: @round.system.id).where(withdrawn: false).order(total_points: :desc).map(&:player_id)
    end
    # TODO: fill_with 1 here links back to user 1 effectively. We need to reseed the DB with a 'bye' player
    pairings.in_groups_of(2, 1).each do |pairing|
      @round.round_individuals.new(player_a_id: pairing[0], player_b_id: pairing[1], player_a_points: 0, player_b_points: 0)
    end
  end

  def rounds_params
    params.require(:round).permit(:round, :finalized, :system_id, round_individuals_attributes: [:player_a_id, :player_b_id, :player_a_points, :player_b_points])
  end
end
