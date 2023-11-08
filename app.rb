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

# Function to check if a user already exists
def user_exists?(csv_data, user_id)
  user_id = user_id.to_i
  csv_data.each do |row|
    return true if row['id'].to_i == user_id
  end
  false
end

# Route to display the list of users
get '/' do
  @csv_data = csv_data
  erb :index
end

# Route to add a new user or update an existing user
post '/create' do
  new_user = {
    id: params[:id],
    user: params[:user],
    status: params[:status]
  }

  if user_exists?(csv_data, new_user[:id])
    existing_user = csv_data.find { |row| row['id'].to_i == new_user[:id].to_i }
    existing_user['user'] = new_user[:user]
    existing_user['status'] = new_user[:status]
  else
    csv_data << [new_user[:id], new_user[:user], new_user[:status]]
  end

  CSV.open(csv_file_path, 'w') do |csv|
    csv << csv_data.headers
    csv_data.each { |row| csv << row }
  end

  redirect '/'
end