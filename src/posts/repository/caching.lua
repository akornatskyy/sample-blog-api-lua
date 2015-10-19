local keys = require 'posts.repository.keys'
local cached

do
    local config = require 'config'
    cached = require 'caching.cached'
    cached = cached.new {
        cache = config.cache,
        time = 3600
    }
end

local function search_posts(self, q, page)
    return self.inner:search_posts(q, page)
end

local function get_post(self, post_id)
    return self.inner:get_post(post_id)
end

return {
    posts = {
        search_posts = cached:get_or_set(keys.search_posts, search_posts),
        get_post = cached:get_or_set(keys.get_post, get_post)
    }
}
