class Ability < ActiveRecord::Base
  validates :name, presence: true
  validates :cooldown, presence: true
  validates :in_game_effect, presence: true

end
