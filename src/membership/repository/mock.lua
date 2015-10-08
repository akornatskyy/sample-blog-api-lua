local _ = require 'shared.mock'

local samples = _.load_samples()
local MembershipRepository = {}


local function find_user_by_id(user_id)
    return _.first(samples.users, function(u)
        return u.id == user_id
    end)
end

function MembershipRepository:get_user(user_id)
    local u = find_user_by_id(user_id)
    return u and {id = tostring(u.id), username = u.username}
end

return {
    membership = MembershipRepository,
    find_user_by_id = find_user_by_id
}
