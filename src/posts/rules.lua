local length = require 'validation.rules.length'
local required = require 'validation.rules.required'


return {
    slug = {required, length{min=2}, length{max=35}}
}
