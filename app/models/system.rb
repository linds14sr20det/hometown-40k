class System < ApplicationRecord
  belongs_to :cohort
  has_one :attachment, inverse_of: :system
  has_many :registrants, :dependent => :restrict_with_error

  has_many :rounds
  has_many :round_aggregates
  accepts_nested_attributes_for :attachment, reject_if: :all_blank, allow_destroy: true
  before_destroy :check_for_registrants

  validates :title, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :registration_open, :presence => true
  validates :registration_close, :presence => true
  validates :description, :presence => true
  validates :max_players, :presence => true
  validates :cost, :presence => true
  validates :round_individuals, numericality: {less_than_or_equal_to: 15}


  def first_image
    html = Nokogiri::HTML.fragment(description)
    image = ActionController::Base.helpers.asset_path("Hometown40K_100x100.png", :digest => false)
    image = html.css('img')[0].attr('src') unless html.css('img')[0].nil?
    image
  end

  def full?
    registrants.paid.count >= max_players
  end

  def descriptive_date
    "#{start_date.strftime("%B %e %Y")} - #{end_date.strftime("%B %e %Y")}"
  end

  def registration_open?
    registration_open < Time.now && Time.now < registration_close
  end

  def active_but_registration_closed?
    cohort.active? && !registration_open?
  end

  def spots_left
    max_players - registrants.where(paid: true).count
  end

  def generate_current_pairings
    current_players = round_aggregates.where(withdrawn: false)

    current_players.each do |player|
      # This algorithm allows for a 50 round tournament, which is more than the population of the earth.
      player.combined_wld_string = "#{player.wins}-#{player.losses}-#{player.draws}"
      player.combined_wld_points = player.wins * 50 + player.draws
    end
    player_brackets = current_players.group_by { |player| player.combined_wld_points }

    # temp = player_brackets.sort_by { |key| key }.reverse!.to_h

    # To here the ordering is working nicely
    # sort now in each grouping

    ranked_players = player_brackets.each { |_key, bracket| bracket.sort_by(&:total_points) }
    ranked_players.map(&:player_id)
  end

  private

  def check_for_registrants
    if registrants.count > 0
      errors.add(:active, 'cannot have another active cohort. Deactivate the active cohort.')
      false
    end
  end
end
