local length = require 'validation.rules.length'
local nonempty = require 'validation.rules.nonempty'
local required = require 'validation.rules.required'

return {
    username = {required, nonempty, length{min=2}, length{max=20}},
    password = {required, nonempty, length{min=8}, length{max=12}}
}
