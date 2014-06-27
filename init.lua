local Template = require('./lib/template')

return function(context)
  return Template:new(context)
end
