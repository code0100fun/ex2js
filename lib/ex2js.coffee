require('coffee-script')
cli = require('commander')
fs = require('fs')
exec = require('child_process').exec
path = require('path')
pack = require('../package.json')
Parser = require('./parser/parser')
Translator = require('./translator/translator')
Compiler = require('./compiler/compiler')

class Ex2js
  quote: (file, callback) ->
    file = path.resolve file
    convert = path.resolve "./bin/convert.exs"
    exec "elixir #{convert} #{file}", (error, stdout, stderr) ->
      callback(stdout)
  parse: (exAst) ->
    new Parser().parse(exAst)
  translate: (exAst) ->
    new Translator().translate(exAst)
  compile: (exAst) ->
    new Compiler().compile(exAst)


module.exports = new Ex2js
