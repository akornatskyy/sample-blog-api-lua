local _ = require 'shared.utils'
local mode = os.getenv('mode') or 'mock'


local sessions = {
    ro = 'ro',
    rw = 'rw'
}

-- repository lifetime: singleton
local repositories = _.load_repositories(sessions, mode, {'public'})

-- service lifetime: per request
local services = _.load_services {'public'}

local Factory = {
    __index = function(self, name)
        local s = setmetatable({factory = self.factory}, services[name])
        self[name] = s
        return s
    end
}

return function(self, func)
    -- TODO: unit of work scope
    self.factory = repositories[self.session_name]
    return func(setmetatable(self, Factory))
end
