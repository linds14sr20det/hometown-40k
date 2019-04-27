class Cohort < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :user
  has_many :systems, inverse_of: :cohort, dependent: :destroy
  accepts_nested_attributes_for :systems, reject_if: :all_blank, allow_destroy: true
  geocoded_by :address

  # ElasticSearch Index
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english'
    end
  end

  after_validation :geocode, if: ->(obj){ obj.address_present? and obj.address_changed? }

  def address
    [street, city, state, country].compact.join(', ')
  end

  def registration_open?
    start_at < Time.now && Time.now < end_at
  end

  def active_but_registration_closed?
    active? && !registration_open?
  end

  def address_present?
    street.present? && city.present? && state.present? && country.present?
  end

  def address_changed?
    street_changed? || city_changed? || state_changed? || country_changed?
  end

  def inactive?
    !active?
  end

end
