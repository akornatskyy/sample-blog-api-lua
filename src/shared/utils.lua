local function merge(t, s)
    for _, d in ipairs(s) do
        t[#t+1] = d
    end
    return t
end

local function load_urls(views)
    local urls = {}
    for i = 1, #views do
        merge(urls, require(views[i] .. '.views'))
    end
    return urls
end

return {
    load_urls = load_urls
}
