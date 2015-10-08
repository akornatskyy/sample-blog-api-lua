local _ = require 'shared.mock'

local samples = _.load_samples()
local MembershipRepository = {}


local function find_user_by_id(user_id)
    return _.first(samples.users, function(u)
        return u.id == user_id
    end)
end

function MembershipRepository:authenticate(username)
    local u = _.first(samples.users, function(u)
        return u.username == username
    end)
    return u and {id = u.id, password = u.password}
end

function MembershipRepository:get_user(user_id)
    local u = find_user_by_id(tonumber(user_id))
    return u and {id = tostring(u.id), username = u.username}
end

function MembershipRepository:has_account(username)
    return _.first(samples.users, function(u)
        return u.username == username
    end) ~= nil
end

function MembershipRepository:create_account(r)
    return false
end

return {
    membership = MembershipRepository,
    find_user_by_id = find_user_by_id
}
