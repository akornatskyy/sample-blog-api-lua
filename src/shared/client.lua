local request = require 'http.functional.request'
local writer = require 'http.functional.response'


local function new()
    local app = assert(require('app'))
    local main = app.new()

    local function path_for(...)
        return app.options.router:path_for(...)
    end

    return function(req)
        local w = writer.new()
        req = request.new(req)
        main(w, req)
        return w, req
    end, path_for
end

return {
    new = new
}
