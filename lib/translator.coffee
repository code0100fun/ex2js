Parser = require './parser'
Module = require '../lib/module'

class Translator

  parse: (source) ->
    parser = new Parser()
    parser.parse(source)

  translate: (source) ->
    exAst = @parse(source)
    { type:'Program', body:[ @statement(exAst).ast() ]}

  statement: (exAst) ->
    statement = switch exAst.name
      when 'defmodule' then new Module(exAst.params[1][0].params[1][0])
    return statement

module.exports = Translator
