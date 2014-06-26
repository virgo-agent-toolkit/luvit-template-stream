local string = require('string')
local stream = require('stream')
local test = require('tape')('test ReadStream')


local Source = stream.Readable:extend()

function Source:initialize(data)
  stream.Readable.initialize(self)

  self.data = data
  self.pos = 1
end

function Source:_read(n)
  if self.pos > string.len(self.data) then
    self:push(nil)
  else
    self:push(string.sub(self.data, self.pos, self.pos + n - 1))
    self.pos = self.pos + n
  end
end

local Sink = stream.Writable:extend()

function Sink:initialize()
  stream.Writable.initialize(self)
  self.text = ""
end

function Sink:_write(data, encoding, cb)
  self.text = self.text .. data
  cb()
end

test('simple', nil, function(t)
  local template = require('..')({foo = 'bar', haha = 42})

  local tmpl = 'foo == {{foo}}, haha == {{haha}}'
  local expected = 'foo == bar, haha == 42'

  local sink = Sink:new()
  sink:once('finish', function()
    t:equal(sink.text, expected, 'incorrect output from Template')
    t:finish()
  end)

  Source:new(tmpl):pipe(template):pipe(sink)
end)

test('missing key', nil, function(t)
  local template = require('..')({foo = 'bar'})

  local tmpl = 'foo == {{foo}}, haha == {{haha}}'
  local expected = 'foo == bar, haha == '

  local sink = Sink:new()
  sink:once('finish', function()
    t:equal(sink.text, expected, 'incorrect output from Template')
    t:finish()
  end)

  Source:new(tmpl):pipe(template):pipe(sink)
end)
