class RacialBonus < ActiveRecord::Base
  include ApplicationHelper

  validates_with UniversalValidator
  validates :cooldown, presence: true
  validates :in_game_effect, presence: true
  validate :validate_race

  belongs_to :race
  has_many :characters

  def validate_race
    if self.race_id == nil
      errors.add(:race_id, "cannot be blank.")
    elsif !self.race
      errors.add(:race, "does not exist.")
    end
  end

  private

  def racial_bonus_params
    params.require(:racial_bonus).permit(:name, :race_id, :cooldown, :in_game_effect, :flavor_text)
  end
end
