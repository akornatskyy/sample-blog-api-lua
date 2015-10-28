local class = require 'core.class'

local cache_profile = require 'public.profile'
local shared = require 'shared.views'


local DailyQuoteHandler = class(shared.BaseHandler, {
    get = function(self)
        self.w.cache_profile = cache_profile.public
        return self:json(self:get_daily_quote())
    end,

    get_daily_quote = function(self)
        return self:factory('ro', function(f)
            return f.quote:daily()
        end)
    end
})


-- url mapping

return {
    {'quote/daily', DailyQuoteHandler, name = 'daily-quote'}
}
