class RoundIndividual < ApplicationRecord
  belongs_to :round
  belongs_to :player_a, :class_name => "User"
  belongs_to :player_b, :class_name => "User"

  def player_a_win?
    return true if player_a_points > player_b_points
    false
  end

  def player_a_loss?
    true if player_a_points < player_b_points
    false
  end
end
