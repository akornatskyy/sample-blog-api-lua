local encoding = require 'core.encoding'
local cipher = require 'security.crypto.cipher'
local digest = require 'security.crypto.digest'
local principal = require 'security.principal'
local ticket = require 'security.crypto.ticket'
local http = require 'http'
local web = require 'web'

local config = require 'config'
local _ = require 'shared.utils'


local options = {
    cache = config.cache,
    principal = principal,
    ticket = ticket.new {
        digest = digest.hmac('ripemd160', 'L6hc@wmA4xWCg6!NrTAGPd'),
        cipher = cipher.new('aes256', 'jmENHqSzGz%SaCd&rAVPPk'),
        encoder = encoding.new('base64')
    }
}

local function new()
    local root_path = options.root_path or '/'
    options.auth_cookie = {
        name = '_a',
        path = root_path,
        -- TODO
        deleted = http.cookie.delete {name = '_a', path = root_path}
    }
    options.urls = _.load_urls {'membership', 'posts', 'public'}
    return web.app({web.middleware.caching, web.middleware.routing}, options)
end

return {options = options, new = new}
