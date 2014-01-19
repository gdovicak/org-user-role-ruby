class SecurityGuard
  attr_accessor :user

  def initialize(user, user_roles)
    @user = user
    @user_roles = user_roles
  end

  def get_role_for(organization)
    role = 'Denied'

    role = check_role_for_org(organization.name, role)
    role = check_role_for_org(organization.parent, role)
    role = check_role_for_org('Root Org', role)

    return role
  end 


  def check_role_for_org(org_name, current_role)
    if(current_role != 'Denied')
      return current_role
    end

    @user_roles.each do |r|
      if r.organization == org_name
        return r.role
      end
    end

    return 'Denied'
  end

end

