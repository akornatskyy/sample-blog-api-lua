local service = {
    daily = function(self)
        return self.factory.quote:get_daily_quote()
    end
}

return service
