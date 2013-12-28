Parser = require './parser'
Module = require './module'
Method = require './method'
BinaryExpression = require './binary_expression'
ExpressionStatement = require './expression_statement'
AssignmentExpression = require './assignment_expression'
Identifier = require './identifier'

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
    if doBlock && typeof(doBlock) == 'object' && Object.keys(doBlock).length > 0
      statements = @statement(doBlock)
      if statements.constructor == Array
        module.methods.push statements...
      else
        module.methods.push statements
    module

  method: (exAst) ->
    params = exAst.params[1]
    name = params[0].name
    mParams = params[0].params[1].map (param) -> param.name
    method = new Method(name, mParams)
    doBlock = params[1]['do']
    if doBlock && typeof(doBlock) == 'object' && Object.keys(doBlock).length > 0
      statements = @statement(doBlock)
      if statements.constructor == Array
        method.body.push statements...
      else
        method.body.push statements
    method

  function: (exAst) ->

  block: (exAst) ->
    exAst.params[1].map (s) => @statement(s)

  binary: (exAst) ->
    operator = exAst.name
    left = exAst.params[1][0].name
    right = exAst.params[1][1].name
    new BinaryExpression(operator, left, right)

  assignment: (exAst) ->
    operator = exAst.name
    left = exAst.params[1][0].name
    right = @expression exAst.params[1][1]
    new AssignmentExpression(operator, left, right)

  expression: (exAst) ->
    switch exAst.name
      when '+' then @binary(exAst)
      when '*' then @binary(exAst)
      when '=' then @assignment(exAst)
      else
        if /\w/.test exAst.name
          new Identifier(exAst.name)
        else
          console.log 'no expression match', exAst

  statement: (exAst) ->
    switch exAst.name
      when 'defmodule' then @module(exAst)
      when 'def' then @method(exAst)
      when '__block__' then @block(exAst)
      when '+', '*', '=' then new ExpressionStatement @expression(exAst)
      else
        new ExpressionStatement(@expression(exAst))

module.exports = Translator
