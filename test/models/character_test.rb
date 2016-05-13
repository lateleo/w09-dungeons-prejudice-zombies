require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  include ApplicationHelper

  test "should be valid with and without backstory" do
    @character = characters(:one)
    assert(@character.valid?, "should be valid without backstory")
    @character.backstory = "Draco Rage."
    assert(@character.valid?, "should be valid with backstory")
  end

  test "should be invalid without a name" do
    @character = characters(:one)
    @character.name = nil
    refute(@character.valid?, "should be invalid without a name")
  end

  test "should be invalid without an age" do
    @character = characters(:one)
    @character.age = nil
    refute(@character.valid?, "should be invalid without an age")
  end

  test "should be invalid without a race" do
    @character = characters(:one)
    @character.race_id = nil
    refute(@character.valid?, "should be invalid without a race")
  end

  test "should be invalid without a racial bonus" do
    @character = characters(:one)
    @character.racial_bonus_id = nil
    refute(@character.valid?, "should be invalid without a racial bonus")
  end

  test "should be invalid without a base_level" do
    @character = characters(:one)
    @character.base_level_id = nil
    refute(@character.valid?, "should be invalid without a base_level")
  end

  test "should be invalid without correct stat_offsets" do
    @character = characters(:one)
    stats.each do |stat|
      @character.send("#{stat}_offset=", nil)
      refute(@character.valid?, "should be invalid with a nil stat offset")
      @character.send("#{stat}_offset=", -1)
      refute(@character.valid?, "should be invalid with a stat offset less than 0")
      @character.send("#{stat}_offset=", 16)
      refute(@character.valid?, "should be invalid with a stat offset greater than 15")
    end
  end

  test "should give correct level values" do
    @character = characters(:one)
    assert_equal(3, @character.char_levels, "should be 3")
    assert_equal(2, @character.class_levels(1), "should be 2")
    assert_equal(1, @character.class_levels(2), "should be 1")
  end

  test "should give correct stat values" do
    @character = characters(:one)
    assert_equal(13, @character.fortitude, "should be 13")
    assert_equal(20, @character.strength, "should be 20")
    assert_equal(18, @character.mana, "should be 18")
    assert_equal(13, @character.swiftness, "should be 13")
    assert_equal(11, @character.intuition, "should be 11")
  end

  test "should give correct number of classes" do
    @character = characters(:one)
    assert_equal(2, @character.char_classes.size, "should be 2")
  end

  test "should give correct number of abilities" do
    @character = characters(:one)
    assert_equal(4, @character.abilities.size, "should be 4")
  end

  test "should filter duplicate attributes properly" do
    @character = characters(:one)
    @character.save
    @dup = @character.dup
    [:abilities, :character_classes, :characters, :races, :racial_bonuses].each do |model|
      @dup.name = send(model, :one).name
      refute(@dup.valid?, "should not allow a duplicate name")
      assert(@dup.errors[:name], "should have an error under :name")
    end
    @dup.name = "duplicate"
    assert(@dup.valid?, "should be valid with unique name but otherwise redundant attributes")
  end

end
