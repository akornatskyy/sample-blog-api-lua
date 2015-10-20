local mixin = require 'core.mixin'
local validation = require 'validation'


local PostsService = mixin({}, validation.mixins.set_error)


function PostsService:search_posts(q, page)
    return self.factory.posts:search_posts(q, page)
end

function PostsService:get_post(slug)
    return self.factory.posts:get_post(slug)
end

function PostsService:list_comments(post_id)
    assert(post_id)
    return self.factory.posts:list_comments(
        post_id, self.principal and self.principal.id)
end

function PostsService:post_permissions(post_id)
    assert(post_id)
    return {
        create_comment = self:can_comment()
    }
end

function PostsService:can_comment()
    if not self.principal then
        return false
    end
    return self.factory.posts:count_comments_awaiting_moderation(
        self.principal.id, 5) < 5
end

function PostsService:add_post_comment(slug, message)
    if not self:can_comment() then
        return self:set_error(
            'There are too many of your comments awaiting ' ..
            'moderation. Come back later, please.')
    end
    local post_id = self.factory.posts:get_post_id(slug)
    if not post_id then
        return self:set_error('We\'re sorry... the post cannot be found.')
    end
    local ok = self.factory.posts:add_post_comment(
        post_id, self.principal.id, message)
    if not ok then
        return self:set_error('We\'re sorry... the comment cannot be added.')
    end
    return true
end

return {
    posts = PostsService
}
