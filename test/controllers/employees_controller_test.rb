require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest

  # For Devise >= 4.1.1
  include Devise::Test::ControllerHelpers

  def setup
    @password = "kitty@123#"
    @confirmed_admin = Admin.create(email: "kitty@payslip.com",
                                  password: @password)
  end

  test "successful login of confirmed admin" do
    sign_in(admin: @confirmed_admin)
    assert_redirected_to employees_path
  end

end