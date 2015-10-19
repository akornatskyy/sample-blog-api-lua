return {
    search_posts = function(q, page)
        return 'p:search_posts:' .. q .. ':' .. page
    end,

    get_post = function(slug)
        return 'p:get_post:' .. slug
    end
}
