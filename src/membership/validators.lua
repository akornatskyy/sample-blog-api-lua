local validator = require 'validation.validator'
local length = require 'validation.rules.length'
local required = require 'validation.rules.required'

local rules = require 'membership.rules'


return {
    credential = validator.new {
        username = {required, length{min=2}, length{max=20}},
        password = rules.password
    },

    password_match = validator.new {
        password = {}
    },

    registration = validator.new {
        email = {required, length{min=6}, length{max=30}}
    },
}
