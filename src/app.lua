local cipher = require 'security.crypto.cipher'
local digest = require 'security.crypto.digest'
local ticket = require 'security.crypto.ticket'
local http = require 'http'
local web = require 'web'

local config = require 'config'
local _ = require 'shared.utils'


local options = {
    urls = _.load_urls {'membership', 'posts', 'public'},
    cache = config.cache,
    ticket = ticket.new {
        --digest = digest.new('sha256'),
        digest = digest.hmac('ripemd160', 'L6hc@wmA4xWCg6!NrTAGPd'),
        cipher = cipher.new {
            cipher = 'aes256',
            key = 'Zef=Rb5tuaYhFKYtt5bBDa_!cyEp2zM4',
            iv = 'SGs67LE6F!r3v3-7'
        },
    },
    auth_cookie = {
        name = '_a'
    },
    principal = require 'security.principal',
    cors = http.cors.new {
        allowed_origins = {'*'}, --{'http://web.local:8080'},
        allow_credentials = true,
        allowed_methods = {'GET', 'HEAD', 'POST'},
        allowed_headers = {'content-type', 'x-requested-with'},
        exposed_headers = {'cache-control', 'etag'},
        max_age = 180
    }
}

local function new()
    options.auth_cookie.path = options.root_path or '/'
    local middlewares = {
        http.middleware.cors,
        http.middleware.caching,
        web.middleware.routing
    }
    return web.app(middlewares, options)
end

return {options = options, new = new}
