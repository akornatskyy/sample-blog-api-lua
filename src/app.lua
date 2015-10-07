local options = {}

local function new()
    local web = require 'web'
    local _ = require 'shared.utils'
    options.urls = _.load_urls {'membership', 'posts', 'public'}
    return web.app({web.middleware.routing}, options)
end

return {options = options, new = new}
