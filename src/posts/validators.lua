local length = require 'validation.rules.length'
local nonempty = require 'validation.rules.nonempty'
local range = require 'validation.rules.range'
local required = require 'validation.rules.required'
local validator = require 'validation.validator'

local rules = require 'posts.rules'


return {
    search_posts = validator.new {
        q = {length{max=20}},
        page = {range{min=0}, range{max=9}}
    },

    post_spec = validator.new {
        slug = rules.slug,
        fields = {length{max=20}}
    },

    post_comment = validator.new {
        slug = rules.slug,
        message = {required, nonempty, length{min=2}, length{max=250}}
    }
}
