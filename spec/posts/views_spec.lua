local client = require 'shared.client'
local describe, it, assert = describe, it, assert


describe('posts.views', function()
    local go, path_for = client.new()

    describe('search posts', function()
    	it('responds with a quote', function()
            local w = go({path = path_for('search-posts')})
            assert.is_nil(w.status_code)
        end)
    end)
end)

