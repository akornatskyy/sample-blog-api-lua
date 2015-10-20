return {
    search_posts = function(q, page)
        return 'p:sepo:' .. q .. ':' .. page
    end,

    get_post_id = function(slug)
        return 'p:gpid:' .. slug
    end,

    get_post = function(slug)
        return 'p:gepo:' .. slug
    end,

    list_comments = function(post_id, author_id)
        if author_id then
            return 'p:lico:' .. post_id .. ':' .. author_id
        end
        return 'p:lico:' .. post_id
    end,

    count_comments_awaiting_moderation = function(user_id)
        return 'p:ccam:' .. user_id
    end
}
