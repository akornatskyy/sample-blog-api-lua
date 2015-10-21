return {
    authenticate = function(username)
        return 'm:auth:' .. username
    end,

    get_user = function(user_id)
        return 'm:geus:' .. user_id
    end,

    has_account = function(username)
        return 'm:haac:' .. username
    end
}
