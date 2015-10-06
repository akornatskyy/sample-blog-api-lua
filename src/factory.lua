local mode = os.getenv('mode') or 'mock'


local sessions = {
    ro = 'ro',
    rw = 'rw'
}

-- repository lifetime: singleton
local repositories
do
    local public = require('public.repository.' .. mode)

    local function mk(session_name, metaclass)
        return setmetatable({session=sessions[session_name]},
                            {__index = metaclass})
    end

    repositories = {
        ro = {
            quote = mk('ro', public.quote)
        }
    }
end

-- service lifetime: per request
local services = {
    quote = {__index = require 'public.service'}
}

local Factory = {
    __index = function(self, name)
        local s = setmetatable({
            factory = repositories[self.session_name]
        }, services[name])
        self[name] = s
        return s
    end
}

return function(self, func)
    -- TODO: unit of work scope
    return func(setmetatable(self, Factory))
end
