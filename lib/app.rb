require 'csv'

# Parse CSV file
csv_file_path = 'data/users_hr_sync.csv'
csv_data = CSV.read(csv_file_path, headers: true)

csv_data.each do |row|
  user_id = row['id']
  user_name = row['user']
  sync_status = row['status']

  puts "User ID: #{user_id}, User Name: #{user_name}, Sync Status: #{sync_status}"
end
