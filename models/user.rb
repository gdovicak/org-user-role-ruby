class User
  attr_accessor :id, :name
  def self.get_current_user
    return User.new
  end
end


class UserRoles
  attr_accessor :user_id

  def find_by(filter)
  end
end
