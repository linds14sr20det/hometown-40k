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
  validates :descriptive_date, :presence => true
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

  private

  def check_for_registrants
    if registrants.count > 0
      errors.add(:active, 'cannot have another active cohort. Deactivate the active cohort.')
      false
    end
  end
end
