class RacialBonus < ActiveRecord::Base
  validates :name, presence: true
  validates :race_id, presence: true
  validates :cooldown, presence: true
  validates :in_game_effect, presence: true

  belongs_to :race
end
