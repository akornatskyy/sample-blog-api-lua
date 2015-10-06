local request = require 'http.functional.request'
local writer = require 'http.functional.response'
local describe, it, assert = describe, it, assert


describe('public.views', function()
    local app = assert(require 'app')

    describe('daily quote', function()
    	it('responds with a quote', function()
            local w = writer.new()
            local req = request.new({path = '/api/v1/quote/daily'})
            app(w, req)
            assert.is_nil(w.status_code)
        end)
    end)
end)
