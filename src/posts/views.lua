local class = require 'core.class'

local shared = require 'shared.views'


local SearchPostsHandler = class(shared.BaseHandler, {
    get = function(self)
        local m = {q = '', page = 0}
        local qs = self.req.query or self.req:parse_query()
        self.errors = {}
        if not self:update_model(m, qs) then
            return self:json_errors()
        end
        self:json(self:search_posts(m.q, m.page))
    end,

    search_posts = function(self, q, page)
        return self:factory('ro', function(f)
            return f.posts:search_posts(q, page)
        end)
    end
})


-- url mapping

return {
    {'search/posts', SearchPostsHandler, name = 'search-posts'}
}
