local client = require 'shared.client'
local describe, it, assert = describe, it, assert


describe('membership.views', function()
    local go, path_for = client.new()

    describe('user', function()
    	it('responds with unauthorized status code', function()
            local w = go({path = path_for('user')})
            assert.equals(401, w.status_code)
        end)
    end)
end)
