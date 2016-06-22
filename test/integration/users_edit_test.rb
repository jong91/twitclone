require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:jon)
  end

  test "unsuccessful edit" do
  	log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "", email: "foo@invalid",
                                    password: "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end
  
  test "successful edit with friendly forwarding" do
  	# User not logged in, so requested URL stored in 
  	# session[:forwarding_url] then log in
  	get edit_user_path(@user)
  	log_in_as(@user)

  	# Redirect to URL in session[:forwarding_url]
  	assert_redirected_to edit_user_path(@user)
  	# Sessions[:forwarding_url] should now be nil

	name = "Foo Bar"
	email = "foo@bar.com"
	patch user_path(@user), user: { name: name, email: email, password: "",
									password_confirmation: ""}
	assert_not flash.empty?
	assert_redirected_to @user
	@user.reload
	assert_equal name, @user.name
	assert_equal email, @user.email

	# On subsequent login attempts, user should be restricted to their profile page
  	assert_nil session[:forwarding_url]
  	log_in_as(@user)
  	assert_redirected_to user_url(@user)
  end
end