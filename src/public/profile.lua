local request_key = require 'http.request_key'

return {
    public = {
        key = request_key.new '$m:$p',
        time = 600
    }
}
