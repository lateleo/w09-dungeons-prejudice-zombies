require 'test_helper'

class LevelTest < ActiveSupport::TestCase
  include ApplicationHelper

  test "should be valid normally" do
    @level = levels(:zero)
    assert(@level.valid?, "should be valid")
    @level = levels(:one)
    assert(@level.valid?, "should be valid")
    @level = levels(:two)
    assert(@level.valid?, "should be valid")
    @level = levels(:three)
    assert(@level.valid?, "should be valid")
  end

  test "should be invalid without a character_id" do
    @level = levels(:one)
    @level.character_id = nil
    refute(@level.valid?, "should be invalid without a character_id")
    @level.character_id = 0
    refute(@level.valid?, "should be invalid with a character_id with no character")
  end

  test "should be invalid without a class_id" do
    @level = levels(:one)
    @level.class_id = nil
    refute(@level.valid?, "should be invalid without a class_id")
    @level.class_id = 0
    refute(@level.valid?, "should be invalid with a class_id with no class")
  end

  test "should be invalid without a ability_id" do
    @level = levels(:one)
    @level.ability_id = nil
    refute(@level.valid?, "should be invalid without a ability_id")
    @level.ability_id = 0
    refute(@level.valid?, "should be invalid with a ability_id with no class")
  end

  test "should be invalid without a character_level" do
    @level = levels(:one)
    @level.character_level = nil
    refute(@level.valid?, "should be invalid without a character_level")
    @level.character_level = -1
    refute(@level.valid?, "should be invalid with a character_level of -1")
  end

  test "should require stat increases to be correct" do
    @level = levels(:zero)
    stats.each do |stat|
      @level.send("#{stat}_increase=", nil)
      refute(@level.valid?, "should be invalid without a stat_increase")
    end
    @level = levels(:one)
    stats.each do |stat|
      @level.send("#{stat}_increase=", 1)
      refute(@level.valid?, "should be invalid with a stat_increase that doesn't match the racial increase")
    end
    @level = levels(:two)
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
