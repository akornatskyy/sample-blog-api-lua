local length = require 'validation.rules.length'
local nonempty = require 'validation.rules.nonempty'
local required = require 'validation.rules.required'


return {
    slug = {required, nonempty, length{min=2}, length{max=35}}
}
