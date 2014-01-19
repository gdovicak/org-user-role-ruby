class SecurityGuard

  def initialize(allowed_roles)
    @allowed_roles = allowed_roles.nil? ? [] : allowed_roles
  end

  def get_role_for(organization)
    role = 'Denied'

    if explicitally_denied?(organization.name)
      return role
    end

    role = check_role_for_org(organization.name, role)
    role = check_role_for_org(organization.parent, role)
    role = check_role_for_org('Root Org', role)

    return role
  end 

  def explicitally_denied?(org_name) 
    @allowed_roles.each do |r|
      if r.organization == org_name and r.role == 'Denied'
        return true
      end
    end

    return false
  end


  def check_role_for_org(org_name, current_role)
    if(current_role != 'Denied')
      return current_role
    end

    @allowed_roles.each do |r|
      if r.organization == org_name
        return r.role
      end
    end

    return 'Denied'
  end

end

