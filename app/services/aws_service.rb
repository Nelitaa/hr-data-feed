require 'aws-sdk-s3'
require 'csv'
require 'dotenv/load'

module AwsService
  def s3_client
    Aws::S3::Client.new(region: ENV['AWS_REGION'])
  end

  def fetch_csv_data(bucket, key)
    s3_object = s3_client.get_object(bucket: bucket, key: key)
    CSV.parse(s3_object.body.read, headers: true)
  end

  def save_csv_data_to_s3(bucket, key, csv_data)
    csv_data_string = CSV.generate do |csv| 
      csv << csv_data.headers
      csv_data.each { |row| csv << row }
    end
    s3_client.put_object(bucket: bucket, key: key, body: csv_data_string)
  end
end
