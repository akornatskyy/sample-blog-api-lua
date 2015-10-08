local PostsService = {}


function PostsService:search_posts(q, page)
    return self.factory.posts:search_posts(q, page)
end

function PostsService:get_post(slug)
    return self.factory.posts:get_post(slug)
end

function PostsService:list_comments(post_id)
    return self.factory.posts:list_comments(
        post_id, self.principal and self.principal.id)
end

function PostsService:post_permissions(post_id)
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

return {
    posts = PostsService
}
