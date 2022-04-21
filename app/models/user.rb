class User < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :cohorts, inverse_of: :user, dependent: :destroy
  has_many :registrants, inverse_of: :user, dependent: :destroy
  has_many :round_aggregates, foreign_key: :player_id, inverse_of: :player
  before_save :downcase_email
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  def is_cohort_to?(cohort)
    cohorts.include?(cohort)
  end

  def is_system_to?(system)
    # TODO: This should eventually allow delegate system TO's
    is_cohort_to?(system.cohort)
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end
end
