local _ = require 'shared.mock'
local find_user_by_id = require('membership.repository.mock').find_user_by_id

local samples = _.load_samples()
local PostsRepository = {}


local function find_post_by_slug(slug)
    return _.first(samples.posts, function(p)
        return p.slug == slug
    end)
end

function PostsRepository:search_posts(q, page)
    local posts = samples.posts
    if q and q ~= '' then
        q = q:lower()
        posts = _.nfilter(posts, (page + 1) * 2 + 1, function(p)
            return p.title:lower():find(q, 1, true)
        end)
    end
    return _.pager(posts, page, 2, function(p)
        local a = find_user_by_id(p.author_id)
        return {
            slug = p.slug,
            title = p.title,
            author = {first_name = a.first_name, last_name = a.last_name},
            created_on = p.created_on,
            message = _.trancate_words(p.message, 40)
        }
    end)
end

function PostsRepository:get_post_id(slug)
    local p = find_post_by_slug(slug)
    return p and p.id
end

function PostsRepository:get_post(slug)
    local p = find_post_by_slug(slug)
    if not p then
        return nil
    end
    local a = find_user_by_id(p.author_id)
    return {
        id = p.id,
        slug = p.slug,
        title = p.title,
        created_on = p.created_on,
        author = {first_name = a.first_name, last_name = a.last_name},
        message = p.message
    }
end

function PostsRepository:list_comments(post_id, author_id)
    local r = {}
    local comments = samples.comments
    author_id = author_id and tonumber(author_id)
    for i = 1, #comments do
        local c = comments[i]
        if c.post_id == post_id and
                (c.moderated or c.author_id == author_id) then
            local a = find_user_by_id(c.author_id)
            r[#r+1] = {
                author = {
                    first_name = a.first_name,
                    last_name = a.last_name,
                    gravatar_hash = a.gravatar_hash
                },
                created_on = c.created_on,
                message = c.message,
                moderated = c.moderated
            }
        end
    end
    return r
end

function PostsRepository:count_comments_awaiting_moderation(user_id, limit)
    user_id = tonumber(user_id)
    return #_.nfilter(samples.comments, limit, function(c)
        return c.author_id == user_id and not c.moderated
    end)
end

function PostsRepository:add_post_comment(post_id, author_id, message)
    table.insert(samples.comments, 1, {
        author_id = tonumber(author_id),
        created_on = os.date('!%Y-%m-%dT%T+00:00'),
        id = '',
        message = message,
        moderated = false,
        post_id = post_id
    })
    return true
end

return {
    posts = PostsRepository
}
