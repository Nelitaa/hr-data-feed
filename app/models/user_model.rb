class UserModel
  attr_accessor :id, :user, :status

  def initialize(id, user, status)
    @id = id
    @user = user
    @status = status
  end

  def user_exists?(csv_data)
    csv_data.any? { |row| row['id'].to_i == @id.to_i }
  end

  def update_user(csv_data)
    existing_user = csv_data.find { |row| row['id'].to_i == @id.to_i }
    existing_user['user'] = @user
    existing_user['status'] = @status
  end

  def add_user(csv_data)
    csv_data << [@id, @user, @status]
  end
end
