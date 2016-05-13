class Character < ActiveRecord::Base
  include ApplicationHelper
  extend ApplicationHelper

  validates_with UniversalValidator
  validates :age, presence: true
  validate :validate_foreign_keys
  validate :validate_offsets

  belongs_to :player, class_name: "User"
  belongs_to :campaign
  belongs_to :race
  belongs_to :racial_bonus

  has_many :levels
  has_many :char_classes, through: :levels, class_name: "CharacterClass"
  has_many :abilities, through: :levels

  def validate_offsets
    stats.each do |stat|
      if self.send("#{stat}_offset") == nil
        errors.add(:"#{stat}_offset", "cannot be blank.")
      elsif self.send("#{stat}_offset") < 0 || self.send("#{stat}_offset") > 15
        errors.add(:"#{stat}_offset", "must be between 0 and 15 inclusive.")
      end
    end
  end

  def validate_foreign_keys
    ["base_level", "player", "race", "racial_bonus"].each do |key|
      if self.send("#{key}_id") == nil
        errors.add(:"#{key}_id", "cannot be blank.")
      elsif !self.send(key)
        errors.add(:"#{key}", "does not exist.")
      end
    end
    racial_matches_race?
  end

  def racial_matches_race?
    if self.race != nil && self.racial_bonus != nil
      if self.racial_bonus.race != self.race
        errors.add(:racial_bonus, "is not available for that Race.")
      end
    end
  end

  def char_levels
    self.levels.size - 1
  end

  def class_levels(char_class_id)
    offset = (self.base_class_id == char_class_id ? 1 : 0)
    self.levels.where(char_class_id: char_class_id).size - offset
  end

  def char_classes
    char_classes = []
    self.levels.each do |level|
      char_class = CharacterClass.find(level.char_class_id)
      char_classes.push(char_class) if !char_classes.include?(char_class)
    end
    char_classes
  end

  def base_level
    self.levels.find_by(character_level: 0)
  end

  def base_level_id
    self.base_level.id
  end

  def base_class
    self.base_level.char_class
  end

  def base_class_id
    self.base_level.char_class_id
  end

  def calculate(stat)
    sum = 0
    self.levels.each {|level| sum += level.send("#{stat}_increase")}
    sum
  end

  stats.each do |stat|
    define_method(:"#{stat}") {calculate(stat)}
  end

  private

  def character_params
    params.require(:character).permit(:name, :age, :campaign_id, :user_id, :race_id,
      :racial_bonus_id, :fortitude_offset, :strength_offset, :mana_offset, :swiftness_offset,
      :backstory)
  end
end
