local class = require 'core.class'

local shared = require 'shared.views'


local EmptyHandler = class(shared.BaseHandler, {
    get = function(self)
        self.w:set_status_code(401)
    end
})

-- url mapping

return {
    {'user', EmptyHandler}
}