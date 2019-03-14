class Cohort < ApplicationRecord
  belongs_to :user
  has_one :info, inverse_of: :cohort
  has_many :systems, inverse_of: :cohort, dependent: :destroy
  accepts_nested_attributes_for :info, reject_if: :all_blank
  accepts_nested_attributes_for :systems, reject_if: :all_blank, allow_destroy: true
  validate :only_one_active_cohort
  scope :active, -> { where(:active => true).first }
  scope :active_validation, -> { where(:active => true) }

  def registration_open?
    start_at < Time.now && Time.now < end_at
  end

  def active_but_registration_closed?
    active? && !registration_open?
  end

  protected

  def only_one_active_cohort
    return unless active?

    matches = Cohort.active_validation
    if persisted?
      matches = matches.where('id != ?', id)
    end
    if matches.exists?
      matches.update_all(:active => false)
    end
  end
end
