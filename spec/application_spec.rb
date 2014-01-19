require_relative '../application'
require_relative '../models/user'
require_relative '../models/org_role_map'

describe Application do
  before(:each) do
    @user = User.new
    @user.id = 645
    @user.name = "Awesome Dude"

    @user_role = OrgRoleMap.new('Org 1', 'User', 'Root Org')

    @org = double()
    @org.stub(:name){'Org 1'}
    @org.stub(:parent){'Root Org'}

    User.stub(:get_current_user).and_return(@user)
    UserRoles.stub(:find_by).with({:user_id => 645 }).and_return([@user_role])
  end

  it "should get the current user" do
    sut = Application.new(@org)
    sut.stub(:render_user_screen)
    sut.run

    expect(User).to have_received(:get_current_user)
  end

  it "should get the current users roles" do
    sut = Application.new(@org)
    sut.run

    expect(UserRoles).to have_received(:find_by).with({:user_id => 645})
  end

  it "render user screen" do
    sut = Application.new(@org)

    sut.stub(:render_user_screen)
    sut.run
    
    expect(sut).to have_received(:render_user_screen).with('Org 1', 'User') 
  end

  it "render admin screen" do
    @user_role = OrgRoleMap.new('Org 1', 'Admin', 'Root Org')
    UserRoles.stub(:find_by).with({:user_id => 645 }).and_return([@user_role])

    sut = Application.new(@org)

    sut.stub(:render_admin_screen)
    sut.run
    
    expect(sut).to have_received(:render_admin_screen).with('Org 1', 'Admin') 
  end

  it "render admin screen" do
    org_role_map = OrgRoleMap.new('Org 1', 'Denied', 'Root Org')
    UserRoles.stub(:find_by).with({:user_id => 645 }).and_return([org_role_map])

    sut = Application.new(@org)

    sut.stub(:render_denied_screen)
    sut.run
    
    expect(sut).to have_received(:render_denied_screen).with('Org 1', 'Denied') 
  end
end

