local class = require 'core.class'
local web = require 'web'


local WelcomeHandler = class({
    get = function(self)
        self.w:write('Hello World!\n')
    end
})

-- url mapping

local all_urls = {
    {'', WelcomeHandler}
}

-- config

local options = {
    urls = all_urls
}

return web.app({web.middleware.routing}, options)
