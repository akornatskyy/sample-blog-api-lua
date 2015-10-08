local MembershipService = {}


function MembershipService:user()
    return self.factory.membership:get_user(self.principal.id)
end

return {
    membership = MembershipService
}
