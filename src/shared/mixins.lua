local ErrorsMixin = {}


function ErrorsMixin:set_error(msg, field)
    self.errors[field or '__ERROR__'] = msg
end

return {
    ErrorsMixin = ErrorsMixin
}
