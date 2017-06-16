require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase

  include ActionDispatch::TestProcess

  def setup
    @employee = Employee.new(first_name: "Ella", last_name: "Tian", annual_salary: 10000,
                             super_rate: 0.9, pay_period: '01 May - 31 May')
    @input_data = {
        "first_name" => "David",
        "last_name" => "Rudd",
        "annual_salary" => 60050,
        "super_rate" => 0.09,
        "pay_period" => "01 March - 31 March"
    }
    @output_data = {
        "name" => "David Rudd",
        "pay_period" => "01 March - 31 March",
        "gross_income" => 5004,
        "income_tax" => 922,
        "net_income" => 4082,
        "super_res" => 450
    }
  end

  test "should be valid" do
    assert @employee.valid?
  end

  test "first name should be present" do
    @employee.first_name = "  "
    assert_not @employee.valid?
  end

  test "last name should be present" do
    @employee.last_name = "  "
    assert_not @employee.valid?
  end

  test "annual salary should be present" do
    @employee.annual_salary = "  "
    assert_not @employee.valid?
  end

  test "super rate should be present" do
    employee = Employee.new(first_name: "Paul", last_name: "Tian", annual_salary: 10000, super_rate: 0.9, pay_period: '01 May - 31 May')
    assert employee.valid?
  end

  test "pay period should be present" do
    @employee.pay_period = "  "
    assert_not @employee.valid?
  end

  test "annual salary should be integer" do
    @employee.annual_salary = 10000
    assert @employee.valid?
    @employee.annual_salary = 10000.02
    assert_not @employee.valid?
  end

  test "annual salary should be greater than 0" do
    @employee.annual_salary = 0
    assert_not @employee.valid?
    @employee.annual_salary = 10000
    assert @employee.valid?
  end


  test "name method in the model" do
    assert_equal @employee.name, @employee.first_name + ' ' + @employee.last_name
  end

  test "rate_level method in the model" do
    #c and income_tax
    test_data = { "David" => [60050, 922], "Ryan" => [120000, 2696] }
    @employee.annual_salary  = test_data["David"][0]
    @employee.save
    assert_equal @employee.rate_level, test_data["David"][1]
    @employee.annual_salary  = test_data["Ryan"][0]
    @employee.save
    assert_equal @employee.rate_level, test_data["Ryan"][1]
  end


  test "calculation_rate method in the model" do

    employee = Employee.create(@input_data)
    assert_equal employee.name, @output_data["name"]
    assert_equal employee.pay_period, @output_data["pay_period"]
    assert_equal employee.gross_income, @output_data["gross_income"]
    assert_equal employee.income_tax, @output_data["income_tax"]
    assert_equal employee.net_income, @output_data["net_income"]
    assert_equal employee.super_res, @output_data["super_res"]
  end

  test "test for self.import method in the model" do
    unless File::exists?( "./test/hello.csv" )
      file = File.new("./test/hello.csv", "w+")
      file.puts "David,Rudd,60050,0.09,01 March - 31 March"
      file.close
    end

    file_hash = {
        :filename => 'hello.csv',
        :content_type => 'application/octet-stream',
        :tempfile => File.new("#{Rails.root}/test/hello.csv")
    }

    upload_file = ActionDispatch::Http::UploadedFile.new(file_hash)
    Employee.import upload_file

    employee_David = Employee.find_or_initialize_by(first_name: 'David', last_name: 'Rudd')

    assert_equal employee_David.name, @output_data["name"]
    assert_equal employee_David.pay_period, @output_data["pay_period"]
    assert_equal employee_David.gross_income, @output_data["gross_income"]
    assert_equal employee_David.income_tax, @output_data["income_tax"]
    assert_equal employee_David.net_income, @output_data["net_income"]
    assert_equal employee_David.super_res, @output_data["super_res"]

  end

end
