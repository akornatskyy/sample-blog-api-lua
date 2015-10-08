local ErrorsMixin = {}


function ErrorsMixin:set_error(msg, field)
    if not field then
        field = '__ERROR__'
    end
    self.errors[field] = msg
end

return {
    ErrorsMixin = ErrorsMixin
}
