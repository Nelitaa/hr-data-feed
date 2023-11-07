require 'csv'
require 'sinatra'

csv_file_path = 'data/users_hr_sync.csv'

# Check if the CSV file exists
if File.exist?(csv_file_path)
  csv_data = CSV.read(csv_file_path, headers: true)
else
  # If the file doesn't exist, create a new one with headers
  CSV.open(csv_file_path, 'w') do |csv|
    csv << ['id', 'user', 'status']
  end
  csv_data = CSV.read(csv_file_path, headers: true)
end

# Route to display the list of users
get '/' do
  @csv_data = csv_data
  erb :index
end

# Route to add a new user
post '/create' do
  new_user = {
    id: params[:id],
    user: params[:user],
    status: params[:status]
  }

  CSV.open(csv_file_path, 'a') do |csv|
    csv << [new_user[:id], new_user[:user], new_user[:status]]
  end

  csv_data = CSV.read(csv_file_path, headers: true)

  redirect '/'
end

# # Add a new user to the CSV file or update it if it already exists

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
# end
