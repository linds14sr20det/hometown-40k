class RoundIndividual < ApplicationRecord
  belongs_to :round
  belongs_to :player_a, :class_name => "User"
  belongs_to :player_b, :class_name => "User"
  attr_accessor :player_a_round_aggregate
  attr_accessor :player_b_round_aggregate

  def player_a_win?
    return true if player_a_points > player_b_points
    false
  end

  def player_a_loss?
    return true if player_a_points < player_b_points
    false
  end

  def player_a_draw?
    return true if player_a_points == player_b_points
    false
  end

  def player_a_score_outcome_string
    if player_a_win?
      "Win: "
    elsif player_a_loss?
      "Loss: "
    else
      "Draw: "
    end
  end

  def player_b_score_outcome_string
    if player_a_win?
      "Loss: "
    elsif player_a_loss?
      "Win: "
    else
      "Draw: "
    end
  end
end
