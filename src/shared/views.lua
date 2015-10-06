local mixin = require 'core.mixin'
local web = require 'web'

local factory = require 'factory'


local BaseHandler = mixin({
    factory = function(self, session_name, func)
        return factory({session_name=session_name}, func)
    end,

    json_error = function(self, msg)
        self.w:set_status_code(400)
        return self:json({['__ERROR__'] = msg})
    end
}, web.mixins.JSONMixin, web.mixins.ModelMixin, web.mixins.RoutingMixin)

return {
    BaseHandler = BaseHandler
}
