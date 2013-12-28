require("coffee-script")
cli = require('commander')
pack = require('../package.json')
fs = require('fs')
Parser = require('./parser')
Translator = require('./translator')
Compiler = require('./compiler')

class Ex2js

  parse: (exAst) ->
    new Parser().parse(exAst)
  translate: (exAst) ->
    new Translator().translate(exAst)
  compile: (exAst) ->
    new Compiler().compile(exAst)


module.exports = new Ex2js
