local client = require 'shared.client'
local describe, it, assert = describe, it, assert


describe('posts.views', function()
    local go, path_for = client.new()

    local signin = function(credentials)
        local w = go {
            method = 'POST',
            path = path_for('signin'),
            body = {username = 'demo', password = 'password'}
        }
        return w.headers['Set-Cookie']:match('^(_a=.-);'), w
    end

    describe('search posts', function()
        local path = path_for('search-posts')

        it('validates query params', function()
            local w = go {path = path, query = {page = 'x'}}
            assert.equals(400, w.status_code)
            local errors = w.data
            assert(errors.page)
        end)

        it('responds with a list of posts', function()
            local w = go {path = path, query = {}}
            local posts = w.data
            assert.equals(2, #posts.items)
            assert.equals(1, posts.paging.after)
        end)

        it('supports paging', function()
            local w = go {path = path, query = {page = 2}}
            local posts = w.data
            assert.equals(2, #posts.items)
            assert.equals(1, posts.paging.before)
            assert.equals(3, posts.paging.after)
        end)

        it('supports query', function()
            local w = go {path = path, query = {q = 'com'}}
            local posts = w.data
            assert.equals(1, #posts.items)
            assert.is_nil(posts.paging.before)
            assert.is_nil(posts.paging.after)
        end)
    end)

    describe('get post', function()
        local path = path_for('post', {slug = 'inventore-hic-voluptatem'})

        it('responds with not found status code', function()
            local w = go {path = path_for('post', {slug = 'unknown'})}
            assert.equals(404, w.status_code)
            assert.same({}, w.headers)
        end)

        it('responds with a post', function()
            local w = go {path = path, query = {}}
            local p = w.data
            assert(p)
            assert.is_nil(p.permissions)
            assert.is_nil(p.comments)
        end)

        it('returns post with permissions', function()
            local w = go {
                path = path,
                query = {fields = 'permissions'}
            }
            local p = w.data
            assert.is_false(p.permissions.create_comment)
        end)

        it('returns post with comments', function()
            local w = go {
                path = path,
                query = {fields = 'comments'}
            }
            local p = w.data
            assert(p.comments)
        end)

        describe('authenticated', function()
            local c = signin()
            local w = go {
                path = path,
                query = {fields = 'permissions'},
                headers = {cookie = c}
            }
            local p = w.data
            assert.is_true(p.permissions.create_comment)
        end)
    end)

    describe('post comments', function()
        local path = path_for('post-comments',
                              {slug = 'inventore-hic-voluptatem'})

        it('prohibits unauthorized access', function()
            local w = go {method = 'POST', path = path}
            assert.equals(401, w.status_code)
            assert.same({}, w.headers)
        end)

        it('validates a message', function()
            local c = signin()
            local w = go {
                method = 'POST',
                path = path,
                headers = {cookie = c}
            }
            assert.equals(400, w.status_code)
            local errors = w.data
            assert(errors.message)
        end)

        it('responds with an error if post cannot be found', function()
            local c = signin()
            local w = go {
                method = 'POST',
                path = path_for('post-comments', {slug = 'unknown'}),
                headers = {cookie = c},
                body = {message = 'Hello'}
            }
            assert.equals(400, w.status_code)
            local errors = w.data
            assert(errors.__ERROR__)
        end)

        it('adds a message', function()
            local c = signin()
            local w = go {
                method = 'POST',
                path = path,
                headers = {cookie = c},
                body = {message = 'Hello'}
            }
            assert.equals(201, w.status_code)
        end)
    end)
end)
