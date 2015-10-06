local json = require 'core.encoding.json'


local function load_samples()
    local info = debug.getinfo(2, 'S')
    local name = info.source:match('@(.*/)') .. 'samples.json'
    local f = io.open(name)
    local c = f:read('*all')
    f:close()
    return json.decode(c)
end

return {
    load_samples = load_samples
}
