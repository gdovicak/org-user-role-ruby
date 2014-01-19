class SecurityGuard
  attr_accessor :user

  def initialize(user, user_roles)
    @user = user
    @user_roles = user_roles
  end

  def get_role_for(organization)
    role = 'Denied'

    @user_roles.each do |r|
      if r.organization == organization.name
        role = r.role
        break
      end
    end

    if(role == 'Denied')
      @user_roles.each do |r|
        puts r.org_parent
        if r.organization == organization.parent
          role = r.role
          break
        end
      end
    end

    if(role == 'Denied')
      @user_roles.each do |r|
        if r.organization == 'Root Org'
          role = r.role
          break
        end
      end
    end

    return role
  end 
end

