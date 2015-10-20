local keys = require 'posts.repository.keys'
local cache
local cached

do
    local config = require 'config'
    cache = config.cache
    cached = require 'caching.cached'
    cached = cached.new {cache = cache, time = 3600}
end

-- region: posts repository

local function search_posts(self, q, page)
    return self.inner:search_posts(q, page)
end

local function get_post_id(self, slug)
    return self.inner:get_post_id(slug)
end

local function get_post(self, slug)
    return self.inner:get_post(slug)
end

local function list_comments(self, post_id, author_id)
    return self.inner:list_comments(post_id, author_id)
end

local function count_comments_awaiting_moderation(self, user_id, limit)
    return self.inner:count_comments_awaiting_moderation(user_id, limit)
end

local function add_post_comment(self, post_id, author_id, message)
    local ok = self.inner:add_post_comment(post_id, author_id, message)
    if ok then
        cache:delete(keys.list_comments(post_id, author_id))
        cache:delete(keys.count_comments_awaiting_moderation(author_id))
    end
    return ok
end

return {
    posts = {
        search_posts = cached:get_or_set(keys.search_posts, search_posts),

        get_post_id = cached:get_or_set(keys.get_post_id, get_post_id),

        get_post = cached:get_or_set(keys.get_post, get_post),

        list_comments = cached:get_or_set(keys.list_comments, list_comments),

        count_comments_awaiting_moderation = cached:get_or_set(
            keys.count_comments_awaiting_moderation,
            count_comments_awaiting_moderation),

        add_post_comment = add_post_comment
    }
}
