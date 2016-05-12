require File.expand_path('../../helpers/application_helper', __FILE__)

class Character < ActiveRecord::Base
  include ApplicationHelper
  
  validates_with UniversalValidator
  validates :age, presence: true
  validates :player_id, presence: true
  validates :race_id, presence: true
  validates :racial_bonus_id, presence: true
  validates :fortitude_offset, presence: true
  validates :strength_offset, presence: true
  validates :mana_offset, presence: true
  validates :swiftness_offset, presence: true
  validates :intuition_offset, presence: true

  belongs_to :race
  belongs_to :racial_bonus

  has_one :base_level, class_name: "Level"
  has_many :levels
  has_many :char_classes, through: :levels, class_name: "CharacterClass"
  has_many :abilities, through: :levels

  def fortitude
    sum = 0
    self.levels.each do |level|
      sum += level.fortitude_increase
    end
  end

  def strength
    sum = 0
    self.levels.each do |level|
      sum += level.strength_increase
    end
  end

  def mana
    sum = 0
    self.levels.each do |level|
      sum += level.mana_increase
    end
  end

  def swiftness
    sum = 0
    self.levels.each do |level|
      sum += level.swiftness_increase
    end
  end

  def intuition
    sum = 0
    self.levels.each do |level|
      sum += level.intuition_increase
    end
  end

  def char_levels
    self.levels.size - 1
  end

  def class_levels(class_id)
    offset = (self.base_level.class_id == class_id ? 1 : 0)
    self.levels.where(class_id: class_id).size - offset
  end

  private

  def character_params
    params.require(:character).permit(:name, :age, :campaign_id, :user_id, :race_id,
      :racial_bonus_id, :fortitude_offset, :strength_offset, :mana_offset, :swiftness_offset,
      :backstory)
  end
end
