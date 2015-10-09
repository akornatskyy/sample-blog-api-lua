local length = require 'validation.rules.length'
local required = require 'validation.rules.required'


return {
    password = {required, length{min=8}, length{max=12}}
}
