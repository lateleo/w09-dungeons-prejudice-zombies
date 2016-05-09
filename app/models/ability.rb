class Ability < ActiveRecord::Base
  validates :name, presence: true
  validates :cooldown, presence: true
  validates :in_game_effect, presence: true

  has_many :levels
  has_and_belongs_to_many :character_classes
end
