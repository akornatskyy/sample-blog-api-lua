local client = require 'shared.client'
local describe, it, assert = describe, it, assert


describe('public.views', function()
    local go, path_for = client.new()

    describe('daily quote', function()
    	it('responds with a quote', function()
            local w = go({path = path_for('daily-quote')})
            assert.is_nil(w.status_code)
        end)
    end)
end)
