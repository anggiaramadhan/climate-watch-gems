# frozen_string_literal: true

class Location < ApplicationRecord
  LOCATION_TYPES = %w[COUNTRY REGION GROUP PROVINCE TERRITORY STATE REGENCY].freeze
  has_many :location_members, dependent: :destroy
  has_many :members, through: :location_members

  validates :iso_code3, presence: true, uniqueness: true
  validates :iso_code2, presence: true, uniqueness: true, if: proc { |l|
    l.show_in_cw? && l.country?
  }
  validates :wri_standard_name, presence: true, if: proc { |l| l.show_in_cw? }
  validates :location_type, presence: true, inclusion: {
    in: LOCATION_TYPES
  }

  before_validation :populate_wri_standard_name, if: proc { |l|
    l.wri_standard_name.blank?
  }

  scope :countries, (-> { where(location_type: 'COUNTRY') })

  def populate_wri_standard_name
    self.wri_standard_name = [
      pik_name, cait_name, ndcp_navigators_name, iso_code3, iso_code2
    ].reject(&:blank?).first
  end

  def country?
    location_type == 'COUNTRY'
  end
end
