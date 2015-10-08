local client = require 'shared.client'
local json = require 'core.encoding.json'
local describe, it, assert = describe, it, assert


describe('public.views', function()
    local go, path_for = client.new()

    describe('daily quote', function()
        local path = path_for('daily-quote')

    	it('responds with a quote', function()
            local w = go {path = path}
            assert.is_nil(w.status_code)
            local q = json.decode(table.concat(w.buffer))
            assert(q.author)
            assert(q.message)
        end)
    end)
end)
