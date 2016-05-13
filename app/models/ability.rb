class Ability < ActiveRecord::Base
  include ApplicationHelper

  validates_with UniversalValidator
  validates :cooldown, presence: true
  validates :in_game_effect, presence: true

  has_many :levels
  has_many :characters, through: :levels
  has_and_belongs_to_many :character_classes

  private

  def ability_params
    params.require(:ability).permit.(:name, :cooldown, :in_game_effect, :flavor_text)
  end
end
