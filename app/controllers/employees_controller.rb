class EmployeesController < ApplicationController

  def index
    @pay_periods = Employee.select(:pay_period).distinct
    if params[:pay_period].present?
      @employees = Employee.where(pay_period: params[:pay_period])
    else
      @employees = Employee.all
    end
  end

  def new
    @employee = Employee.new
  end


  def create
    begin
      @file = params.require(:employee)[:file]
      Employee.import(@file)
      redirect_to employees_path
    rescue Exception => exception
      @employee = Employee.new
      flash[:error] = "导入失败! #{ exception.message }"
      render action: :new, formats: [:html]
    end
  end

end
