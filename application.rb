require_relative 'models/user'
require_relative 'security_guard'

class Application
  attr_accessor :org

  def initialize(org)
    @org = org
  end

  def run
    user = User.get_current_user
    roles = UserRoles.find_by user_id: user.id

    guard = SecurityGuard.new(roles)
    role = guard.get_role_for(@org)
    
    if role == 'User'
      render_user_screen(@org.name, role)
    end

    if role == 'Admin'
      render_admin_screen(@org.name, role)
    end

    if role == 'Denied'
      render_denied_screen(@org.name, role)
    end

  end

  def render_user_screen(org_name, role)
  end

  def render_admin_screen(org_name, role)
  end

  def render_denied_screen(org_name, role)
  end

end
