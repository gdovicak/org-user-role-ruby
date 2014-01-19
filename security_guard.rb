class SecurityGuard
  attr_accessor :user

  def initialize(user, user_roles)
    @user = user
    @user_roles = user_roles
  end

  def get_role_for(organization)

    @user_roles.each do |r|
      if r.organization == organization.name
        return 'User'
      end
    end

    return 'Admin'
  end 
end

