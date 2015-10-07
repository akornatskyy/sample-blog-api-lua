local function extend(t, s)
    for i = 1, #s do
        t[#t+1] = s[i]
    end
    return t
end

local function load_repositories(sessions, mode, names)
    local r = {}
    mode = '.repository.' .. mode
    for session_name, session in pairs(sessions) do
        r[session_name] = {}
        for i = 1, #names do
            local module = require(names[i] .. mode)
            for name, metaclass in pairs(module) do
                r[session_name][name] = setmetatable(
                    {session=sessions[session_name]},
                    {__index = metaclass}
                )
            end
        end
    end
    return r
end

local function load_services(names)
    local s = {}
    for i = 1, #names do
        local module = require(names[i] .. '.service')
        for name, metaclass in pairs(module) do
            s[name] = {__index = metaclass}
        end
    end
    return s
end

local function load_urls(views)
    local urls = {}
    for i = 1, #views do
        extend(urls, require(views[i] .. '.views'))
    end
    return urls
end

return {
    load_repositories = load_repositories,
    load_services = load_services,
    load_urls = load_urls
}
