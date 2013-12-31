Parser = require '../parser/parser'
Module = require './patterns/module'
Method = require './patterns/method'
BinaryExpression = require './expressions/binary_expression'
ExpressionStatement = require './statements/expression_statement'
AssignmentExpression = require './expressions/assignment_expression'
CallExpression = require './expressions/call_expression'
MemberExpression = require './expressions/member_expression'
Identifier = require './types/identifier'
Literal = require './types/literal'

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

    mParams = params[0].params[1]
    mParams = if mParams then mParams.map((param) -> param.name) else []
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

  call: (exAst) ->
    callee = @expression exAst
    args = @expression exAst
    new CallExpression(callee, args)

  member: (exAst) ->
    obj = @expression exAst.params[1][0]
    property = @expression exAst.params[1][1]
    new MemberExpression(obj, property)

  aliases: (exAst) ->
    new Identifier(exAst.aliases[0])

  expression: (exAst) ->
    unless exAst.name?
      if @literal exAst
        return new Literal(exAst)
      else if @identifier exAst
        return new Identifier(exAst)

    switch exAst.name
      when '+' then @binary(exAst)
      when '*' then @binary(exAst)
      when '=' then @assignment(exAst)
      when '.' then @member(exAst)
      when '__aliases__' then @aliases(exAst)
      else
        if typeof(exAst.name) == 'object'
          console.log '%j', exAst.params[1]
          args = exAst.params[1]
          args = args.map (a) => @expression(a)
          new CallExpression(@expression(exAst.name), args)
        else
          args = exAst.params[1]
          if args? && args.length > 0
            args = args.map (a) => @expression(a)
            new CallExpression(exAst.name, args)
          else if @literal exAst.name
            new Literal(exAst.name)
          else if @identifier exAst.name
            new Identifier(exAst.name)
          else
            throw 'No expression match'

  identifier: (value) ->
    /\w/.test value

  literal: (value) ->
    /".*"|\d/.test value

  statement: (exAst) ->
    switch exAst.name
      when 'defmodule' then @module(exAst)
      when 'def' then @method(exAst)
      when '__block__' then @block(exAst)
      when '+', '*', '=', '.' then new ExpressionStatement @expression(exAst)
      else
        new ExpressionStatement(@expression(exAst))

module.exports = Translator
