require_relative '../security_guard'

describe SecurityGuard do
  describe "should return 'Admin' role when the user has 'Admin' role for" do
    before(:each) do
      @user = double()
      @organization = double()
      @organization.stub(:name) { 'Org 1' }
      @organization.stub(:parent) { 'Root Org' }

      @org_role_map = double()
      @org_role_map.stub(:user_id) {1}
    end

    it "the organization requested" do
      @org_role_map.stub(:organization) { 'Org 1' }
      @org_role_map.stub(:role) { 'Admin' }
      @org_role_map.stub(:parent) { nil }

      sut = SecurityGuard.new(@user, [@org_role_map])
      role = sut.get_role_for(@organization)
      expect(role).to eq('Admin')
    end

    it "the organizations requsted's parent" do
        @org_role_map.stub(:organization) { 'Root Org' }
        @org_role_map.stub(:role) { 'Admin' }
        @org_role_map.stub(:parent) { nil }

        sut = SecurityGuard.new(@user, [@org_role_map])
        role = sut.get_role_for(@organization)
        expect(role).to eq('Admin')
    end
  end


  describe "should return 'User' role when the user has 'User' role for" do

    before(:each) do
      @user = double()
      @organization = double()
      @organization.stub(:name) { 'Org 1' }
      @organization.stub(:parent) { 'Root Org' }

      @org_role_map = double()
      @org_role_map.stub(:user_id) {1}
    end

    it "the organization requested" do
      @org_role_map.stub(:organization) { 'Org 1' }
      @org_role_map.stub(:role) { 'User' }
      @org_role_map.stub(:parent) { 'Root Org' }

      sut = SecurityGuard.new(@user, [@org_role_map])
      role = sut.get_role_for(@organization)
      expect(role).to eq('User')
    end
  end

end

