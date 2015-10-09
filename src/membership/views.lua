local class = require 'core.class'

local shared = require 'shared.views'
local validators = require 'membership.validators'


local SignInHandler = class(shared.BaseHandler, {
    post = function(self)
        local m = {username='', password=''}
        self.errors = {}
        if not self:update_model(m) or
                not self:validate(m, validators.credential) or
                not self:authenticate(m) then
            return self:json_errors()
        end
        return self:json {username = m.username}
    end,

    authenticate = function(self, credential)
        local user = self:factory('ro', function(f)
            return f.membership:authenticate(credential)
        end)
        if not user then
            return false
        end
        self:set_principal {id = user.id}
        return true
    end
})


local SignUpHandler = class(shared.BaseHandler, {
    post = function(self)
        local m = {email = '', username = '', password = ''}
        local p = {password = '', confirm_password = ''}
        self.errors = {}
        if not self:update_model(m) or
                not self:update_model(p) or
                not self:validate(m, validators.registration) or
                not self:validate(p, validators.password_match) or
                not self:create_account(m) then
            return self:json_errors()
        end
        return self:json {}
    end,

    create_account = function(self, m)
        return self:factory('rw', function(f)
            if not f.membership:create_account(m) then
                return false
            end
            -- TODO
            -- f.session.commit()
            return true
        end)
    end
})


local SignOutHandler = class(shared.BaseHandler, {
    get = function(self)
        self:set_principal()
        return self:json {}
    end
})


local UserHandler = class(shared.BaseHandler, {
    get = function(self)
        local p = self:get_principal()
        if not p then
            return self.w:set_status_code(401)
        end
        local u = self:get_user()
        return self:json {username = u.username}
    end,

    get_user = function(self)
        return self:factory('ro', function(f)
            return f.membership:user()
        end)
    end
})

-- url mapping

return {
    {'signin', SignInHandler, name = 'signin'},
    {'signup', SignUpHandler, name = 'signup'},
    {'signout', SignOutHandler, name = 'signout'},
    {'user', UserHandler, name = 'user'}
}
