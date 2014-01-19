require_relative '../security_guard'
require_relative '../models/org_role_map'

describe SecurityGuard do
  before(:each) do
    @org_role_map = double()
    @org_role_map.stub(:user_id) {1}

    @organization = double()
    @organization.stub(:name) { 'Org 1' }
    @organization.stub(:parent) { 'Root Org' }

    @user = double()
  end

  it "should return 'Denied' if nil is passed for roles" do
    sut = SecurityGuard.new( nil)
    role = sut.get_role_for(@organization)
    expect(role).to eq('Denied')
  end

  describe "should return 'Admin' role when the user has 'Admin' role for" do

    it "the organization requested" do
      org_role_map = OrgRoleMap.new('Org 1', 'Admin', 'Root Org')

      sut = SecurityGuard.new( [org_role_map])
      role = sut.get_role_for(@organization)
      expect(role).to eq('Admin')
    end

    it "the requsted organization's parent" do
        org_role_map = OrgRoleMap.new('Root Org', 'Admin', nil)

        sut = SecurityGuard.new( [org_role_map])
        role = sut.get_role_for(@organization)
        expect(role).to eq('Admin')
    end
  end

  describe "should return 'User' role when the user has 'User' role for" do

    it "the organization requested" do
      org_role_map = OrgRoleMap.new('Org 1', 'User', 'Root Org')

      sut = SecurityGuard.new( [org_role_map])
      role = sut.get_role_for(@organization)
      expect(role).to eq('User')
    end

    it "the requsted organization's parent" do
      org_role_map = OrgRoleMap.new('Root Org', 'User', nil)

      sut = SecurityGuard.new( [org_role_map])
      role = sut.get_role_for(@organization)
      expect(role).to eq('User')
    end

    it "the root organization" do
      org_role_map = OrgRoleMap.new('Root Org', 'User', nil)

      organization = double()
      @organization.stub(:name) { 'Child Org 1' }
      @organization.stub(:parent) { 'Org 1' }

      sut = SecurityGuard.new( [org_role_map])
      role = sut.get_role_for(@organization)
      expect(role).to eq('User')
    end

  end

  describe "should return 'Denied' role when the user " do
    describe " has 'Denied' role for" do
      it "the organization requested" do
        org_role_map = OrgRoleMap.new('Org 1', 'Denied', 'Root Org')

        sut = SecurityGuard.new( [org_role_map])
        role = sut.get_role_for(@organization)
        expect(role).to eq('Denied')
      end

      it "the requsted organization's parent" do
        organization = double()
        @organization.stub(:name) { 'Child Org 1' }
        @organization.stub(:parent) { 'Org 1' }

        org_role_map = OrgRoleMap.new('Org 1', 'Denied', 'Root Org')

        sut = SecurityGuard.new( [org_role_map])
        role = sut.get_role_for(@organization)
        expect(role).to eq('Denied')
      end
    end

    it "does not have a role specfied" do
      org_role_map = OrgRoleMap.new('Org 1', 'Denied', 'Root Org')

      sut = SecurityGuard.new( [])
      role = sut.get_role_for(@organization)
      expect(role).to eq('Denied')
    end
  end 

  describe "inherit rolls for multiple children" do
    before(:each) do
      @child1 = double()
      @child1.stub(:name){'Child 1'}
      @child1.stub(:parent){'Org 2'}

      @child2 = double()
      @child2.stub(:name){'Child 2'}
      @child2.stub(:parent){'Org 2'}
    end

    it "when parent has user role" do
      org_role_map = OrgRoleMap.new('Org 2', 'User', 'Root Org')

      sut = SecurityGuard.new([org_role_map])
      expect(sut.get_role_for(@child1)).to eq('User')
      expect(sut.get_role_for(@child2)).to eq('User')
    end

    it "when root org has user role" do
      org_role_map = OrgRoleMap.new('Root Org', 'User', nil)

      sut = SecurityGuard.new([org_role_map])
      expect(sut.get_role_for(@child1)).to eq('User')
      expect(sut.get_role_for(@child2)).to eq('User')

    end

    it "unless child org is specifically denied" do
      org_role_map = OrgRoleMap.new('Root Org', 'User', nil)
      denied_org_role_map = OrgRoleMap.new('Child 2', 'Denied', 'Org 2')

      sut = SecurityGuard.new([org_role_map, denied_org_role_map])
      expect(sut.get_role_for(@child1)).to eq('User')
      expect(sut.get_role_for(@child2)).to eq('Denied')
    end
  end

end

