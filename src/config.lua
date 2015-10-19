local cache = os.getenv('cache') or 'null'

if cache == 'null' then
    cache = require('caching.null')
    cache = cache.new()
elseif cache == 'libmemcached' then
    local libmemcached = require 'libmemcached'
    local encoder = require 'core.encoding.json'
    cache = assert(libmemcached.new(
        '--server=127.0.0.1:11211 --binary-protocol',
        encoder))
else
    error('cache "' .. cache .. '" is not supported')
end

return {
    cache = cache
}
