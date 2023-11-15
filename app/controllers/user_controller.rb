require 'sinatra'
require_relative '../models/user_model'
require_relative '../services/aws_service'

class UserController < Sinatra::Base
  include AwsService

  configure do
    set :views, 'app/views'
  end
  
  before do
    @csv_data = fetch_csv_data(ENV['AWS_S3_BUCKET'] || 'hd-data-2023', ENV['AWS_FILE_NAME'])
  end

  get '/' do
    erb :index
  end

  post '/create' do
    new_user = UserModel.new(params[:id], params[:user], params[:status])

    if new_user.user_exists?(@csv_data)
      new_user.update_user(@csv_data)
    else
      new_user.add_user(@csv_data)
    end

    save_csv_data_to_s3(ENV['AWS_S3_BUCKET'] || 'hd-data-2023', ENV['AWS_FILE_NAME'], @csv_data)
    redirect '/'
  end

  put '/update/:id' do
    user_id = params[:id]
    updated_user = UserModel.new(user_id, params[:user], params[:status])

    if updated_user.user_exists?(@csv_data)
      updated_user.update_user(@csv_data)
      save_csv_data_to_s3(ENV['AWS_S3_BUCKET'] || 'hd-data-2023', ENV['AWS_FILE_NAME'], @csv_data)
    end

    redirect '/'
  end
end
