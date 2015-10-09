local validator = require 'validation.validator'
local length = require 'validation.rules.length'
local required = require 'validation.rules.required'

local rules = require 'posts.rules'


return {
    search_posts = validator.new {
        q = {length{max=20}},
        page = {}
    },

    post_spec = validator.new {
        slug = rules.slug,
        fields = {}
    },

    post_comment = validator.new {
        slug = rules.slug,
        message = {required, length{min=2}, length{max=250}}
    }
}
