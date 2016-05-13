require 'test_helper'

class LevelTest < ActiveSupport::TestCase
  include ApplicationHelper

  test "should be valid normally" do
    @level = levels(:tyrion_zero)
    assert(@level.valid?, "should be valid")
    @level = levels(:tyrion_one)
    assert(@level.valid?, "should be valid")
    @level = levels(:tyrion_two)
    assert(@level.valid?, "should be valid")
    @level = levels(:tyrion_three)
    assert(@level.valid?, "should be valid")
  end

  test "should be invalid without a character_id" do
    @level = levels(:tyrion_one)
    @level.character_id = nil
    refute(@level.valid?, "should be invalid without a character_id")
    @level.character_id = 6
    refute(@level.valid?, "should be invalid with a nonexistent character")
  end

  test "should be invalid without a correct class_id" do
    @level = levels(:tyrion_zero)
    @level.char_class = nil
    refute(@level.valid?, "should be invalid without a class_id")
    @level.char_class_id = 9
    refute(@level.valid?, "should be invalid with a nonexistent class")
    @level.char_class = character_classes(:vanguard)
    refute(@level.valid?, "level zero should be invalid with a prestige class")
    @level = levels(:tyrion_one)
    @level.char_class = character_classes(:vanguard)
    refute(@level.valid?, "class for level one should match level zero")
    @level = levels(:tyrion_three)
    @level.char_class = character_classes(:mage)
    refute(@level.valid?, "should be invalid with a different base class than level 0")
  end

  test "should be invalid without a correct ability_id" do
    @level = levels(:tyrion_one)
    @level.ability = nil
    refute(@level.valid?, "should be invalid without an ability_id")
    @level.ability_id = 9
    refute(@level.valid?, "should be invalid with a nonexistent ability")
    @level.ability = abilities(:crusader_strike)
    refute(@level.valid?, "should be invalid with a duplicate ability_id for that character")
    @level.ability = abilities(:fireball)
    refute(@level.valid?, "should be invalid with the id for an ability not available to that class")
  end

  test "should be invalid without a correct character_level" do
    @level = levels(:tyrion_one)
    @level.character_level = nil
    refute(@level.valid?, "should be invalid without a character_level")
    @level.character_level = -1
    refute(@level.valid?, "should be invalid with a character_level of -1")
    @level = levels(:tyrion_three)
    @level.character_level = 2
    refute(@level.valid?, "should be invalid with a duplicate character_level for that character")
  end

  test "should require stat increases to be correct" do
    @level = levels(:tyrion_zero)
    stats.each do |stat|
      @level.send("#{stat}_increase=", nil)
      refute(@level.valid?, "should be invalid without a stat_increase")
    end
    @level = levels(:tyrion_one)
    stats.each do |stat|
      @level.send("#{stat}_increase=", 1)
      refute(@level.valid?, "should be invalid with a stat_increase that doesn't match the racial increase")
    end
    @level = levels(:tyrion_two)
    stats.each do |stat|
      original = @level.send("#{stat}_increase")
      @level.send("#{stat}_increase=", original+1)
      refute(@level.valid?, "should be invalid when the stat increase sum is too high")
      @level.send("#{stat}_increase=", original-1)
      refute(@level.valid?, "should be invalid when the stat increase is too low")
      @level.send("#{stat}_increase=", original)
    end
    @level.swiftness_increase = 4
    @level.strength_increase = 1
    refute(@level.valid?, "should be invalid when a stat is above the limit for the class")
  end
end
