require 'csv'
require 'sinatra'
require 'aws-sdk-s3'
require 'dotenv/load'
require 'yaml'

# Path to the CSV file
csv_file_path = 'data/users_hr_sync.csv'

# Load AWS S3 credentials from the config file
config = YAML.load_file('config/config.yml')&.[](settings.environment.to_s) || {}

# Extract AWS S3 credentials
s3_credentials = {
  access_key_id: config['aws_access_key_id'],
  secret_access_key: config['aws_secret_access_key'],
  region: config['aws_region']
}

# Initialize AWS S3 client
s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'])

# Download CSV file from S3
s3_object = s3.get_object(bucket: ENV['AWS_S3_BUCKET'], key: 'users_hr_sync.csv')
csv_data = CSV.parse(s3_object.body.read, headers: true)

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
