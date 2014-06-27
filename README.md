luvit-template-stream
=====================

Package `template-stream` exports a factory function that takes an argument
table `context`, which includes key/value pairs to replace in a template file.
The function returns a `Template` instance, which is a `Transform` stream that
populates values specified in `context` into the strings coming in, and writes
out new strings with values replaced.

The variables in the template should be in the form of `{{variable_name}}``.

## Example

The following example uses `stream-fs` for input template file, pipes it into a
`Template` instance that holds a context object `{name = 'World'}`, and pipes
the `Template` instance into `process.stdout`.

```
local fs = require('stream-fs')
fs.ReadStream:new('./example.tmpl'):pipe(process.stdout)
local template = require('template-stream')({name = 'World'})
fs.ReadStream:new('./example.tmpl'):pipe(template):pipe(process.stdout)
```

```
$ luvit example.lua
Hello, {{name}}!
Hello, World!
```
