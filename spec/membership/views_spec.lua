local request = require 'http.functional.request'
local writer = require 'http.functional.response'
local describe, it, assert = describe, it, assert


describe('membership.views', function()
    local app = assert(require 'app')

    describe('user', function()
    	it('responds with unauthorized status code', function()
            local w = writer.new()
            local req = request.new({path = '/api/v1/user'})
            app(w, req)
            assert.equals(401, w.status_code)
        end)
    end)
end)

