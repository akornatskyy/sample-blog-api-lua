local class = require 'core.class'

local shared = require 'shared.views'


local EmptyHandler = class(shared.BaseHandler, {
    get = function(self)
        self:json({})
    end
})


-- url mapping

return {
    {'search/posts', EmptyHandler}
}
