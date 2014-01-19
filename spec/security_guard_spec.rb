require_relative '../security_guard'
require_relative '../models/org_role_map'

describe SecurityGuard do
  before(:each) do
    @org_role_map = double()

    @organization = double()
    @organization.stub(:name) { 'Org 1' }
    @organization.stub(:parent) { 'Root Org' }

    @user = double()
  end

  describe "should return 'Admin' role when the user has 'Admin' role for" do
    before(:each) do
      @org_role_map.stub(:user_id) {1}
    end

    it "the organization requested" do
      org_role_map = OrgRoleMap.new('Org 1', 'Admin', 'Root Org')

      sut = SecurityGuard.new(@user, [org_role_map])
      role = sut.get_role_for(@organization)
      expect(role).to eq('Admin')
    end

    it "the requsted organization's parent" do
        org_role_map = OrgRoleMap.new('Root Org', 'Admin', nil)

        sut = SecurityGuard.new(@user, [org_role_map])
        role = sut.get_role_for(@organization)
        expect(role).to eq('Admin')
    end
  end

  describe "should return 'User' role when the user has 'User' role for" do

    before(:each) do
      @org_role_map.stub(:user_id) {1}
    end

    it "the organization requested" do
      org_role_map = OrgRoleMap.new('Org 1', 'User', 'Root Org')

      sut = SecurityGuard.new(@user, [org_role_map])
      role = sut.get_role_for(@organization)
      expect(role).to eq('User')
    end

    it "the requsted organization's parent" do
      org_role_map = OrgRoleMap.new('Root Org', 'User', nil)

      sut = SecurityGuard.new(@user, [org_role_map])
      role = sut.get_role_for(@organization)
      expect(role).to eq('User')
    end

    it "the root organization" do
      org_role_map = OrgRoleMap.new('Root Org', 'User', nil)

      organization = double()
      @organization.stub(:name) { 'Child Org 1' }
      @organization.stub(:parent) { 'Org 1' }

      sut = SecurityGuard.new(@user, [org_role_map])
      role = sut.get_role_for(@organization)
      expect(role).to eq('User')
    end

  end
end

