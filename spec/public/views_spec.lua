local client = require 'shared.client'
local describe, it, assert = describe, it, assert


describe('public.views', function()
    local go, path_for = client.new()

    describe('daily quote', function()
        local path = path_for('daily-quote')

    	it('responds with a quote', function()
            local w = go {path = path}
            local q = w.data
            assert(q.author)
            assert(q.message)
        end)
    end)
end)
