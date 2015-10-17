local validator = require 'validation.validator'
local compare = require 'validation.rules.compare'
local email = require 'validation.rules.email'
local length = require 'validation.rules.length'
local required = require 'validation.rules.required'

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
        email = {required, length{min=6}, length{max=30}, email},
        username = rules.username
    },
}
