local mixin = require 'core.mixin'
local validation = require 'validation'


local MembershipService = mixin({}, validation.mixins.set_error)


function MembershipService:user()
    return self.factory.membership:get_user(self.principal.id)
end

function MembershipService:authenticate(c)
    local up = self.factory.membership:authenticate(c.username:lower())
    if not up or up.password ~= c.password then
        return self:set_error(
            'The username or password provided is incorrect.')
    end
    return self.factory.membership:get_user(up.id)
end

function MembershipService:create_account(r)
    if self.factory.membership:has_account(r.username) then
        return self:set_error(
            'The user with such username is already registered. ' ..
            'Please try another.',
            'username')
    end
    if not self.factory.membership:create_account(r) then
        return self:set_error(
            'The system was unable to create an account for you. ' ..
            'Please try again later.')
    end
    return true
end

return {
    membership = MembershipService
}
