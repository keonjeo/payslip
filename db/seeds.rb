if ENV["seed_file"].nil?
  load(Rails.root.join( 'db', 'seeds', "development.rb"))
else
  begin
    load(Rails.root.join( 'db', 'seeds', "#{ENV["seed_file"]}.rb"))
  rescue Exception => exception
    Rails.logger  "#{ exception.message }"
  end

end