local QuoteService = {}


function QuoteService:daily()
    return self.factory.quote:get_daily_quote()
end

return {
    quote = QuoteService
}
