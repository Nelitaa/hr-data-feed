require 'csv'
require 'sinatra'
require 'aws-sdk-s3'
require 'dotenv/load'

# Initialize AWS S3 client
S3 = Aws::S3::Client.new(region: ENV['AWS_REGION'])

# Function to retrieve CSV data from S3
def fetch_csv_data
  s3_object = S3.get_object(bucket: ENV['AWS_S3_BUCKET'] || 'hd-data-2023', key: ENV['AWS_FILE_NAME'])
  CSV.parse(s3_object.body.read, headers: true)
end

# Function to check if a user already exists
def user_exists?(csv_data, user_id)
  user_id = user_id.to_i
  csv_data.any? { |row| row['id'].to_i == user_id }
end

# Function to update user information
def update_user(csv_data, user_id, new_user_data)
  existing_user = csv_data.find { |row| row['id'].to_i == user_id.to_i }
  existing_user['user'] = new_user_data[:user]
  existing_user['status'] = new_user_data[:status]
end

# Function to add a new user
def add_user(csv_data, new_user_data)
  csv_data << [new_user_data[:id], new_user_data[:user], new_user_data[:status]]
end

# Function to save CSV data to S3
def save_csv_data_to_s3(csv_data)
  csv_data_string = CSV.generate do |csv|
    csv << csv_data.headers
    csv_data.each { |row| csv << row }
  end
  S3.put_object(bucket: ENV['AWS_S3_BUCKET'] || 'hd-data-2023', key: ENV['AWS_FILE_NAME'], body: csv_data_string)
end

before do
  @csv_data = fetch_csv_data
end

# Route to display the list of users
get '/' do
  erb :index
end

# Route to create a new user
post '/create' do
  new_user = {
    id: params[:id],
    user: params[:user],
    status: params[:status]
  }

  if user_exists?(@csv_data, new_user[:id])
    update_user(@csv_data, new_user[:id], new_user)
  else
    add_user(@csv_data, new_user)
  end

  save_csv_data_to_s3(@csv_data)

  redirect '/'
end

# Route to update user information
put '/update/:id' do
  user_id = params[:id]
  updated_user_data = {
    user: params[:user],
    status: params[:status]
  }

  if user_exists?(@csv_data, user_id)
    update_user(@csv_data, user_id, updated_user_data)
    save_csv_data_to_s3(@csv_data)
  end

  redirect '/'
end
