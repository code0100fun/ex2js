_ = require 'underscore'
AstBuilder = require '../ast_builder'
ReturnStatement = require('../statements/return_statement')

class BlockStatement
  constructor: (@params) ->
    @_body = []
  addStatement: (statement) ->
    @_body.push statement
  statements: ->
    @_body[0..-2]
  return: ->
    [$...,last] = @_body
    if last?
      if last.type() != 'ReturnStatement'
        new ReturnStatement(last.expression)
      else
        last
  body: ->
    @statements().concat(@return() || [])
  ast: ->
    _.extend { rest:null, generator:false, expression:false },  @buildAst('body')

_.extend BlockStatement::, AstBuilder::

module.exports = BlockStatement
