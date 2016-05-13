require 'test_helper'

class CampaignTest < ActiveSupport::TestCase

  test "should be valid when created normally" do
    @campaign = campaigns(:one)
    assert(@campaign.valid?, "should be valid")
  end

  test "should be invalid without a name" do
    @campaign = campaigns(:one)
    @campaign.name = nil
    refute(@campaign.valid?, "should be invalid without a name")
  end

  test "should be invalid without a description" do
    @campaign = campaigns(:one)
    @campaign.description = nil
    refute(@campaign.valid?, "should be invalid without a description")
  end

  test "should filter dm_id properly" do
    @campaign = campaigns(:one)
    @campaign.dm_id = nil
    refute(@campaign.valid?, "should be invalid without a dm_id")
    @campaign = campaigns(:two)
    refute(@campaign.valid?, "should be invalid with a dm_id for a user that doesn't exist")
    @campaign.dm_id = 2
    assert(@campaign.valid?, "should be valid with a duplicate dm_id")
  end

end
