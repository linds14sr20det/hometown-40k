class RoundAggregate < ApplicationRecord
  belongs_to :system
  belongs_to :player, :class_name => "User"
  attr_accessor :combined_wld
end
