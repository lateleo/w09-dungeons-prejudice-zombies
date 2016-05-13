require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  include ApplicationHelper

  test "should be valid when created normally" do
    @character = characters(:tyrion)
    assert(@character.valid?, "should be valid without a backstory or campaign")
    @character.backstory = "Draco Rage."
    assert(@character.valid?, "should be valid with a backstory, but no campaign")
    @character.campaign = campaigns(:sea)
    assert(@character.valid?, "should be valid with a backstory and a campaign")
    @character.backstory = nil
    assert(@character.valid?, "should be valid with a campaign, but no backstory")
  end

  test "should be invalid without a name" do
    @character = characters(:tyrion)
    @character.name = nil
    refute(@character.valid?, "should be invalid without a name")
  end

  test "should be invalid without an age" do
    @character = characters(:tyrion)
    @character.age = nil
    refute(@character.valid?, "should be invalid without an age")
  end

  test "should be invalid without a correct race" do
    @character = characters(:tyrion)
    @character.race = nil
    refute(@character.valid?, "should be invalid without a race")
  end

  test "should be invalid without a correct racial_bonus" do
    @character = characters(:tyrion)
    @character.racial_bonus = nil
    refute(@character.valid?, "should be invalid without a racial_bonus_id")
    @character.racial_bonus_id = 5
    refute(@character.valid?, "should be invalid with a nonexistent racial_bonus")
    @character.racial_bonus = racial_bonuses(:sprint)
    refute(@character.valid?, "should be invalid with a racial_bonus for a different race")
  end

  test "should be invalid without correct stat_offsets" do
    @character = characters(:tyrion)
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
    @character = characters(:tyrion)
    assert_equal(3, @character.char_levels, "should be 3")
    assert_equal(2, @character.class_levels(character_classes(:paladin).id), "should be 2")
    assert_equal(1, @character.class_levels(character_classes(:vanguard).id), "should be 1")
  end

  test "should give correct stat values" do
    @character = characters(:tyrion)
    assert_equal(13, @character.fortitude, "should be 13")
    assert_equal(20, @character.strength, "should be 20")
    assert_equal(18, @character.mana, "should be 18")
    assert_equal(13, @character.swiftness, "should be 13")
    assert_equal(11, @character.intuition, "should be 11")
  end

  test "should give correct number of classes" do
    @character = characters(:tyrion)
    assert_equal(2, @character.char_classes.size, "should be 2")
  end

  test "should give correct number of abilities" do
    @character = characters(:tyrion)
    assert_equal(4, @character.abilities.size, "should be 4")
  end

  test "should filter duplicate attributes properly" do
    @character = characters(:darren)
    [Ability, CharacterClass, Character, Race, RacialBonus].each do |model|
      @character.name = model.first.name
      refute(@character.valid?, "should not allow a duplicate name")
      assert(@character.errors[:name], "should have an error under :name")
    end
    @character.name = "Darren Wingfury"
    assert(@character.valid?, "should be valid with unique name but otherwise redundant attributes")
  end

end
