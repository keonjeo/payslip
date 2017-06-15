require 'csv'
class Employee < ApplicationRecord

  validates :first_name, :last_name, :annual_salary, :super_rate, :pay_period, presence: true
  validates :annual_salary, numericality: { only_integer: true, greater_than: 0 }

  before_validation(on: :create) do
    calculation_rate
  end

  def name
    "#{first_name} #{last_name}"
  end

  def rate_level
    tax = case annual_salary
          when 0..18200
            0
          when 18201..37000
            (0.19 * (annual_salary - 18200))
          when 37001..80000
            (3572 + (annual_salary - 37000) * 0.325)
          when 80001..180000
            (17547 + (annual_salary - 80000) * 0.37)
          when 180001..Float::INFINITY
            (54547 + (annual_salary - 180000) * 0.45)
          end
    tax.zero? ? 0 : (tax / 12).round
  end


  private
  def calculation_rate
    if annual_salary.present?
      self.gross_income = (annual_salary / 12).round
      self.income_tax = rate_level
      self.net_income = gross_income - income_tax
      self.super_res = (gross_income * super_rate).round
    end
  end

  class << self

    def import(file)
      raise "请选择csv文件上传!" unless file.is_a?(ActionDispatch::Http::UploadedFile)
      CSV.foreach(file.tempfile) do |row|
        data = {
            first_name: row[0].strip,
            last_name: row[1].strip,
            annual_salary: row[2].strip,
            super_rate: row[3],
            pay_period: row[4]
        }
        employee = Employee.find_or_initialize_by(first_name: data[:first_name], last_name: data[:last_name])
        employee.update_attributes!(data)
      end
    end
  end

end
