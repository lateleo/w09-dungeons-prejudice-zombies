require File.expand_path('../../helpers/application_helper', __FILE__)

class RacialBonus < ActiveRecord::Base
  include ApplicationHelper

  validates_with UniversalValidator
  validates :race_id, presence: true
  validates :cooldown, presence: true
  validates :in_game_effect, presence: true
  validate :validate_race_id

  belongs_to :race
  has_many :characters

  def validate_race_id
    unless self.race
      errors.add(:racial_id, "must correspond to the id of a Race that exists.")
    end
  end

  private

  def racial_bonus_params
    params.require(:racial_bonus).permit(:name, :race_id, :cooldown, :in_game_effect, :flavor_text)
  end
end
