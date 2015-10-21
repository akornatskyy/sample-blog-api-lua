local keys = require 'membership.repository.keys'
local cache
local cached

do
    local config = require 'config'
    cache = config.cache
    cached = require 'caching.cached'
    cached = cached.new {cache = cache, time = 3600}
end

-- region: membership repository

local function authenticate(self, username)
    return self.inner:authenticate(username)
end

local function get_user(self, user_id)
    return self.inner:get_user(user_id)
end

local function has_account(self, username)
    return self.inner:has_account(username)
end

local function create_account(self, r)
    return self.inner:create_account(r)
end

return {
    membership = {
        authenticate = cached:get_or_set(keys.authenticate, authenticate),

        get_user = cached:get_or_set(keys.get_user, get_user),

        has_account = cached:get_or_set(keys.has_account, has_account),

        create_account = create_account
    }
}
