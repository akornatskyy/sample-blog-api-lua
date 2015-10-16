local mixin = require 'core.mixin'
local web = require 'web'

local factory = require 'factory'


local BaseHandler = mixin(
    {},
    web.mixins.authcookie,
    web.mixins.json,
    web.mixins.locale,
    web.mixins.model,
    web.mixins.principal,
    web.mixins.routing,
    web.mixins.validation
)

mixin(BaseHandler, {
    factory = function(self, session_name, func)
        return factory({
            session_name = session_name,
            errors = self.errors,
            principal = self:get_principal()
        }, func)
    end
})

return {
    BaseHandler = BaseHandler
}
