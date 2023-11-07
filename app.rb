require 'csv'
require 'sinatra'

csv_file_path = 'data/users_hr_sync.csv'
@csv_data = CSV.read(csv_file_path, headers: true)

# Route to display the list of users
get '/' do
  erb :index
end

# # Check if the CSV file exists
# if File.exist?(csv_file_path)
#   csv_data = CSV.read(csv_file_path, headers: true)
# else
#   # If the file doesn't exist, create a new one with headers
#   CSV.open(csv_file_path, 'w') do |csv|
#     csv << ['id', 'user', 'status']
#   end
#   csv_data = CSV.read(csv_file_path, headers: true)
# end


# csv_data.each do |row|
#   user_id = row['id']
#   user_name = row['user']
#   sync_status = row['status']

#   puts "User ID: #{user_id}, User Name: #{user_name}, Sync Status: #{sync_status}"
# end

# # Add a new user to the CSV file or update it if it already exists
# new_user = {
#   id: '9',
#   user: 'Miriam',
#   status: 'synchronized'
# }

# def user_exists?(csv_data, user_id)
#   user_id = user_id.to_i
#   csv_data.each do |row|
#     return true if row['id'].to_i == user_id
#   end
#   false
# end

# if user_exists?(csv_data, new_user[:id])
#   user_id = new_user[:id].to_i

#   # Create a new array with the updated data
#   updated_data = csv_data.map do |row|
#     if row['id'].to_i == user_id
#       [new_user[:id], new_user[:user], new_user[:status]]
#     else
#       row.fields
#     end
#   end

#   # Replace the contents of the CSV file with the new updated array
#   CSV.open(csv_file_path, 'w') do |csv|
#     csv << csv_data.headers
#     updated_data.each { |row| csv << row }
#   end

#   puts "User with ID #{new_user[:id]} updated."
# else
#   # Add a new user in a new row
#   CSV.open(csv_file_path, 'a') do |csv|
#     csv << [new_user[:id], new_user[:user], new_user[:status]]
#   end
#   puts "New user added to the CSV file."
# end
