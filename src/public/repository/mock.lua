local _ = require 'shared.mock'

local samples = _.load_samples()

local quote = {
    get_daily_quote = function(self)
        return samples.quote
    end
}

return {
    quote = quote
}
