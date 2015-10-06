local request = require 'http.functional.request'
local writer = require 'http.functional.response'
local describe, it, assert = describe, it, assert


describe('posts.views', function()
    local app = assert(require 'app')

    describe('search posts', function()
    	it('responds with a quote', function()
            local w = writer.new()
            local req = request.new({path = '/api/v1/search/posts'})
            app(w, req)
            assert.is_nil(w.status_code)
        end)
    end)
end)

