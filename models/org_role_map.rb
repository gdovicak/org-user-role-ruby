class OrgRoleMap
  attr_accessor :organization, :role, :org_parent

  def initialize(org_name, role, parent) 
    @organization = org_name 
    @role = role
    @org_parent = parent
  end
end
