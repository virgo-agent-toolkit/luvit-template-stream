local string = require('string')
local Transform = require('stream').Transform

local Template = Transform:extend()

function Template:initialize(context)
  Transform.initialize(self)

  self.context = context
end

function Template:_transform(t, encoding, callback)
  callback(nil, string.gsub(t, '{{(%a[%w_]*)}}', function(k)
    return tostring(self.context[k])
  end))
end

return Template
