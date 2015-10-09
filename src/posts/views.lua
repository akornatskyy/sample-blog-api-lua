local class = require 'core.class'

local shared = require 'shared.views'
local validators = require 'posts.validators'


local SearchPostsHandler = class(shared.BaseHandler, {
    get = function(self)
        local m = {q = '', page = 0}
        local qs = self.req.query or self.req:parse_query()
        self.errors = {}
        if not self:update_model(m, qs) or
                not self:validate(m, validators.search_posts) then
            return self:json_errors()
        end
        self:json(self:search_posts(m.q, m.page))
    end,

    search_posts = function(self, q, page)
        return self:factory('ro', function(f)
            return f.posts:search_posts(q, page)
        end)
    end
})

local PostHandler = class(shared.BaseHandler, {
    get = function(self)
        local m = {slug = '', fields = ''}
        local qs = self.req.query or self.req:parse_query()
        self.errors = {}
        if not self:update_model(m, self.req.route_args) or
                not self:update_model(m, qs) or
                not self:validate(m, validators.post_spec) then
            return self:json_errors()
        end
        local p = self:get_post(m.slug, m.fields)
        if not p then
            return self.w:set_status_code(404)
        end
        return self:json(p)
    end,

    get_post = function(self, slug, fields)
        return self:factory('ro', function(f)
            local p, post_id = f.posts:get_post(slug)
            if not p then
                return nil
            end
            if fields then
                if fields:find('permissions', 1, true) then
                    p.permissions = f.posts:post_permissions(post_id)
                end
                if fields:find('comments', 1, true) then
                    p.comments = f.posts:list_comments(post_id)
                end
            end
            return p
        end)
    end
})

local PostCommentsHandler = class(shared.BaseHandler, {
    post = function(self)
        if not self:get_principal() then
            return self.w:set_status_code(401)
        end
        local m = {slug = '', message = ''}
        self.errors = {}
        if not self:update_model(m, self.req.route_args) or
                not self:update_model(m) or
                not self:validate(m, validators.post_comment) or
                not self:add_post_comment(m) then
            return self:json_errors()
        end
        self.w:set_status_code(201)
        return self:json {}
    end,

    add_post_comment = function(self, m)
        return self:factory('rw', function(f)
            if not f.posts:add_post_comment(m.slug, m.message) then
                return false
            end
            -- TODO
            -- f.session.commit()
            return true
        end)
    end
})

-- url mapping

return {
    {'search/posts', SearchPostsHandler, name = 'search-posts'},
    {'post/{slug}', PostHandler, name = 'post'},
    {'post/{slug}/comments', PostCommentsHandler, name = 'post-comments'}
}
