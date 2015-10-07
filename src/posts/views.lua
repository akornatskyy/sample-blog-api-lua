local class = require 'core.class'

local shared = require 'shared.views'


local SearchPostsHandler = class(shared.BaseHandler, {
    get = function(self)
        self:json({})
    end
})


-- url mapping

return {
    {'search/posts', SearchPostsHandler, name = 'search-posts'}
}
