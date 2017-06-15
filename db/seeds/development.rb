puts "[#{Time.now}] ---- Start to seed data ----"

#---默认管路员创建----
Admin.create(email: 'admin@payslip.com', password: 'admin123')

puts "[#{Time.now}] ---- Seed data done ----"
