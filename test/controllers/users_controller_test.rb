require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    post :create, user: {name: "Art", email: "art@email.com", password: "11223344", password_confirmation: "11223344"}
    assert_redirected_to users_path
  end

  test "should fail to create" do
    post :create, user: {name: "Art", email: "art@email.com", password: "112233", password_confirmation: "11223344"}
    assert_template :new
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should redirect from show to login" do
    @user = User.create!(name: "Art", email: "art@email.com", password: "11223344", password_confirmation: "11223344")
    get :show, id: @user.id
    assert_redirected_to login_path
  end

  test "should login and get show page" do
    @user = User.create!(name: "Art", email: "art@email.com", password: "11223344", password_confirmation: "11223344")
    login_user(user=@user, route=login_path)
    get :show, id: @user.id
    assert_response :success
  end

end
