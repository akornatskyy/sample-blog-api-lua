local web = require 'web'

local _ = require 'shared.utils'


local options = {
    root_path = '/api/v1/',
    urls = _.load_urls {'membership', 'posts', 'public'}
}

return web.app({web.middleware.routing}, options)
