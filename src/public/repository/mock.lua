local _ = require 'shared.mock'

local samples = _.load_samples()
local QuoteRepository = {}


function QuoteRepository:get_daily_quote()
    return samples.quote
end

return {
    quote = QuoteRepository
}
