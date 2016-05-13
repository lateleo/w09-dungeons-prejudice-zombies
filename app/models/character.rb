require File.expand_path('../../helpers/application_helper', __FILE__)

class Character < ActiveRecord::Base
  include ApplicationHelper

  validates_with UniversalValidator
  validates :age, presence: true
  validates :player_id, presence: true
  validates :race_id, presence: true
  validates :racial_bonus_id, presence: true
  validates :base_level_id, presence: true
  validate :validate_offsets

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
    sum
  end

  def strength
    sum = 0
    self.levels.each do |level|
      sum += level.strength_increase
    end
    sum
  end

  def mana
    sum = 0
    self.levels.each do |level|
      sum += level.mana_increase
    end
    sum
  end

  def swiftness
    sum = 0
    self.levels.each do |level|
      sum += level.swiftness_increase
    end
    sum
  end

  def intuition
    sum = 0
    self.levels.each do |level|
      sum += level.intuition_increase
    end
    sum
  end

  def char_levels
    self.levels.size - 1
  end

  def class_levels(class_id)
    offset = (self.base_level.class_id == class_id ? 1 : 0)
    self.levels.where(class_id: class_id).size - offset
  end

  def char_classes
    classes = []
    self.levels.each do |l|
      char_class = CharacterClass.find(l.class_id)
      classes.push(char_class) if !classes.include?(char_class)
    end
    classes
  end

  def base_class
    self.base_level.char_class
  end

  def base_class_id
    self.base_level.char_class_id
  end

  def launch_pry
    binding.pry
  end

  def validate_offsets
    stats.each do |stat|
      if self.send("#{stat}_offset") == nil
        errors.add(:"#{stat}_offset", "cannot be blank.")
      elsif self.send("#{stat}_offset") < 0 || self.send("#{stat}_offset") > 15
        errors.add(:"#{stat}_offset", "must be between 0 and 15 inclusive.")
      end
    end
  end

  private

  def character_params
    params.require(:character).permit(:name, :age, :campaign_id, :user_id, :race_id,
      :racial_bonus_id, :fortitude_offset, :strength_offset, :mana_offset, :swiftness_offset,
      :backstory)
  end
end
