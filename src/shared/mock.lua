local json = require 'core.encoding.json'

local function map(t, f, s, e)
    if not s then
        s = 1
    end
    if not e then
        e = #t
    end
    local r = {}
    local j = 1
    for i = s, e do
        r[j] = f(t[i])
        j = j + 1
    end
    return r
end

local function trancate_words(s, count)
    local n = count
    local r = {}
    s = s:gsub('\\n', ' ')
    for i in s:gmatch('%S+') do
        if n == 0 then
            r[#r + 1] = '...'
            break
        end
        r[#r + 1] = i
        n = n - 1
    end
    return table.concat(r, ' ')
end

local function pager(items, page, size, f)
    local n = #items
    if n == 0 then
        return {}
    end
    local s = page * size + 1
    local e = s + size - 1
    local paging = {}
    if page > 0 then
        paging.before = page - 1
    end
    if e < n then
        paging.after = page + 1
    else
        e = n
    end
    return {
        paging = paging,
        items = map(items, f, s, e)
    }
end

local function first(items, predicate)
    for i = 1, #items do
        local d = items[i]
        if predicate(d) then
            return d
        end
    end
end

local function nfilter(items, n, predicate)
    local r = {}
    for i = 1, #items do
        local d = items[i]
        if predicate(d) then
            r[#r + 1] = d
            n = n - 1
            if n == 0 then
                break
            end
        end
    end
    return r
end

local function load_samples()
    local info = debug.getinfo(2, 'S')
    local name = info.source:match('@(.*/)') .. 'samples.json'
    local f = io.open(name)
    local c = f:read('*all')
    f:close()
    return json.decode(c)
end

return {
    trancate_words = trancate_words,
    pager = pager,
    first = first,
    nfilter = nfilter,
    load_samples = load_samples
}
