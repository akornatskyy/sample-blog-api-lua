local length = require 'validation.rules.length'
local required = require 'validation.rules.required'


return {
    username = {required, length{min=2}, length{max=20}},
    password = {required, length{min=8}, length{max=12}}
}
