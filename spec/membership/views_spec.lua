local client = require 'shared.client'
local describe, it, assert = describe, it, assert


describe('membership.views', function()
    local go, path_for = client.new()

    local signin = function(credentials)
        if not credentials then
            credentials = {username = 'demo', password = 'password'}
        end
        local w = go {
            method = 'POST',
            path = path_for('signin'),
            body = credentials
        }
        local c = w.headers['Set-Cookie']
        if not c then
            return nil, w
        end
        return c:match('^(_a=.-);'), w
    end

    describe('signin', function()
        local path = path_for('signin')

    	it('validates user credentials', function()
            local w = go {method = 'POST', path = path}
            assert.equals(400, w.status_code)
            local errors = w.data
            assert(errors.username)
            assert(errors.password)
        end)

    	it('responds with error if user is not found', function()
            local auth_cookie, w = signin {
                username = 'unknown', password = 'password'
            }
            assert.is_nil(auth_cookie)
            assert.equals(400, w.status_code)
            local errors = w.data
            assert(errors.__ERROR__)
        end)

    	it('issues auth cookie', function()
            local auth_cookie, w = signin()
            assert(auth_cookie)
            local u = w.data
            assert.equals('demo', u.username)
        end)
    end)

    describe('signup', function()
        local path = path_for('signup')

    	it('validates registration information', function()
            local w = go {method = 'POST', path = path}
            assert.equals(400, w.status_code)
            local errors = w.data
            assert(errors.email)
        end)

    	it('checks if username is taken already', function()
            local w = go {
                method = 'POST',
                path = path,
                body = {username = 'demo', email = 'demo@somewhere.com'}
            }
            assert.equals(400, w.status_code)
            local errors = w.data
            assert(errors.username)
        end)
    end)

    describe('signout', function()
        local path = path_for('signout')

    	it('removes auth cookie', function()
            local auth_cookie = signin()
            local w = go {path = path, headers = {cookie = auth_cookie}}
            assert.equals(
                '_a=; Expires=Thu, 01 Jan 1970 00:00:00 GMT; Path=/',
                w.headers['Set-Cookie'])
        end)
    end)

    describe('user', function()
        local path = path_for('user')

    	it('responds with unauthorized status code', function()
            local w = go {path = path}
            assert.equals(401, w.status_code)
        end)

    	it('confirms user is authenticated', function()
            local auth_cookie = signin()
            local w = go {path = path, headers = {cookie = auth_cookie}}
            local u = w.data
            assert.equals('demo', u.username)
        end)
    end)
end)
