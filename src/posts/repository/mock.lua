local _ = require 'shared.mock'
local find_user_by_id = require('membership.repository.mock').find_user_by_id

local samples = _.load_samples()
local PostsRepository = {}


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

return {
    posts = PostsRepository
}
