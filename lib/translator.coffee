Parser = require './parser'
Module = require './module'
Method = require './method'
BinaryExpression = require './binary_expression'
ExpressionStatement = require './expression_statement'

class Translator

  parse: (source) ->
    parser = new Parser()
    parser.parse(source)

  translate: (source) ->
    exAst = @parse(source)
    { type:'Program', body:[ @statement(exAst).ast() ]}

  module: (exAst) ->
    params = exAst.params[1]
    name = params[0].params[1][0]
    module = new Module(name, params)
    doBlock = params[1]['do']
    module.methods.push(@statement(doBlock)) if doBlock
    module

  method: (exAst) ->
    params = exAst.params[1]
    name = params[0].name
    mParams = params[0].params[1].map (param) -> param.name
    method = new Method(name, mParams)
    doBlock = params[1]['do']
    method.body.push(@statement(doBlock)) if doBlock
    method

  function: (exAst) ->

  add: (exAst) ->
    expression = new BinaryExpression('+', 'a', 'b')
    new ExpressionStatement(expression)

  statement: (exAst) ->
    switch exAst.name
      when 'defmodule' then @module(exAst)
      when 'def' then @method(exAst)
      when '+' then @add(exAst)

  expression: (exAst) ->

module.exports = Translator
