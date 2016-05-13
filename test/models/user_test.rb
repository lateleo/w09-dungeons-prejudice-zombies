require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should be valid when created normally" do
    @user = users(:art)
    assert(@user.valid?, "should be valid")
  end

  test "should be invalid without email" do
    @user = users(:art)
    @user.email = nil
    refute(@user.valid?, "should be invalid without email")
  end

  test "should be invalid without name" do
    @user = users(:art)
    @user.name = nil
    refute(@user.valid?, "should be invalid without name")
  end

  test "should be invalid without correct password" do
    @user = User.new(email: "artburtch@gmail.com", name: "Art 2")
    @user.password_confirmation = "12345678"
    refute(@user.valid?, "should be invalid without password")
    @user.password_confirmation = nil
    refute(@user.valid?, "should be invalid without password_confirmation, even though it matches")
    @user.password = "12345678"
    refute(@user.valid?, "should be invalid without password_confirmation")
    @user.password = "1234567"
    @user.password_confirmation = @user.password
    refute(@user.valid?, "should be invalid when both are less than 8 characters")
  end

  test "should filter duplicates properly" do
    @user = User.new(email: "artburtch@gmail.com", name: "Art Burtch", password: "password", password_confirmation: "password")
    refute(@user.valid?, "should be invalid with duplicate name")
    @user.name = "Arthur Burtch"
    assert(@user.valid?, "should be valid with unique name/email, but reused password/confirmation")
    @user.email = "artburtch@huskers.unl.edu"
    refute(@user.valid?, "should be invalid with duplicate email")
  end
end
