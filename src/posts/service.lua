local PostsService = {}


function PostsService:search_posts(q, page)
    return self.factory.posts:search_posts(q, page)
end

return {
    posts = PostsService
}
