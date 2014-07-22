local string = require('string')
local Transform = require('stream').Transform

local Template = Transform:extend()

function Template:initialize(context)
  Transform.initialize(self)

  self.context = context
end

function Template:_transform(t, encoding, callback)
  callback(nil, string.gsub(t, '{{(%a[%w_]*)}}', function(k)
    if self.context[k] == nil then
      -- keep the variable so that maybe it'll be replaced by a downstream
      -- Template
      return '{{' .. k .. '}}'
    end
    return tostring(self.context[k])
  end))
end

return Template
