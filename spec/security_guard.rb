require_relative '../security_guard'

describe SecurityGuard do
      it "the organization specificed" do
        user = double()
        user_roles = double()
        organization = double()

        sut = SecurityGuard.new(user, user_roles)
        role = sut.get_role_for(organization)
        expect(role).to eq('Admin')

        expec(sut.user).to eq(user)
      end
end

