local keys = require 'public.repository.keys'
local cached

do
    local config = require 'config'
    cached = require 'caching.cached'
    cached = cached.new {
        cache = config.cache,
        time = 3600
    }
end

local function get_daily_quote(self)
    return self.inner:get_daily_quote()
end

return {
    quote = {
        get_daily_quote = cached:get_or_set(keys.get_daily_quote,
                                            get_daily_quote),
    }
}
