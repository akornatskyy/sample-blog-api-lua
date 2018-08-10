local compare = require 'validation.rules.compare'
local email = require 'validation.rules.email'
local length = require 'validation.rules.length'
local nonempty = require 'validation.rules.nonempty'
local required = require 'validation.rules.required'
local validator = require 'validation.validator'

local rules = require 'membership.rules'


return {
    credential = validator.new {
        username = rules.username,
        password = rules.password
    },

    password_match = validator.new {
        password = {
            compare{equal='confirm_password', msg='Passwords do not match.'}
        }
    },

    registration = validator.new {
        email = {required, nonempty, length{min=6}, length{max=30}, email},
        username = rules.username
    },
}
