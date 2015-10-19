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
            local caching  = require(names[i] .. '.repository.caching')
            for name, metaclass in pairs(module) do
                local repository = setmetatable(
                    {session=sessions[session_name]},
                    {__index = metaclass}
                )
                if caching then
                    metaclass = caching[name]
                    if metaclass then
                        metaclass = setmetatable(metaclass,
                            {__index = repository})
                        repository = setmetatable(
                            {inner = repository},
                            {__index = metaclass}
                        )
                    end
                end
                r[session_name][name] = repository
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
