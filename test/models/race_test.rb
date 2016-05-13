require 'test_helper'

class RaceTest < ActiveSupport::TestCase
  include ApplicationHelper

  test "should be valid with and without description" do
    @race = races(:one)
    assert(@race.valid?, "should be valid without description")
    @race.description = "Very boring."
    assert(@race.valid?, "should be valid with description")
  end

  test "should be invalid without a name" do
    @race = races(:one)
    @race.name = nil
    refute(@race.valid?, "should be invalid without a name")
  end

  test "should be invalid without a singular form" do
    @race = races(:one)
    @race.singular = nil
    refute(@race.valid?, "should be invalid without a singular form")
  end

  test "should create adjective only when blank" do
    @race = races(:one)
    @race.adjective = nil
    @race.valid?
    assert_equal(@race.adjective, @race.singular, "adjective should match singular if not specified")
    @race.adjective = "humane"
    @race.valid?
    assert_equal("humane", @race.adjective, "adjective should not be changed if specified")
  end

  test "should be invalid without an age_of_maturity" do
    @race = races(:one)
    @race.age_of_maturity = nil
    refute(@race.valid?, "should be invalid without an age_of_maturity")
  end

  test "should be invalid without correct stat_indices" do
    @race = races(:one)
    stats.each do |stat|
      @race.send("#{stat}_index=", nil)
      refute(@race.valid?, "should be invalid with a nil stat index")
      @race.send("#{stat}_index=", 1)
      refute(@race.valid?, "should be invalid with a stat index sum of 1")
      @race.send("#{stat}_index=", 0)
    end
    @race.mana_index = 4
    @race.strength_index = -4
    refute(@race.valid?, "should be invalid with stats outside of -3 to 3")
  end

  test "increase_levels gives proper results" do
    @race = races(:one)
    @race.mana_index = 3
    assert_equal([2,4,5,7,9,10,12,14,15], @race.increase_levels_for("mana"), "array should match the values for 3")
    @race.mana_index = 2
    assert_equal([2,4,6,8,10,12,14,15], @race.increase_levels_for("mana"), "array should match the values for 2")
    @race.mana_index = 1
    assert_equal([3,5,7,9,11,13,15], @race.increase_levels_for("mana"), "array should match the values for 1")
    @race.mana_index = 0
    assert_equal([3,5,8,10,13,15], @race.increase_levels_for("mana"), "array should match the values for 0")
    @race.mana_index = -1
    assert_equal([3,6,9,12,15], @race.increase_levels_for("mana"), "array should match the values for -1")
    @race.mana_index = -2
    assert_equal([4,8,12,15], @race.increase_levels_for("mana"), "array should match the values for -2")
    @race.mana_index = -3
    assert_equal([5,10,15], @race.increase_levels_for("mana"), "array should match the values for -3")
  end

end
