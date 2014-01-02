_ = require 'underscore'
ReturnStatement = require '../statements/return_statement'
AstBuilder = require '../ast_builder'

class FunctionExpression
  constructor: (@params) ->
    @body = []
  body: undefined
  bodyAst: ->
    statmentsAst = []
    for statement, i in @body
      if i == (@body.length - 1) && statement.type() != 'ReturnStatement'
        statement = new ReturnStatement(statement.expression)
      statmentsAst.push statement.ast()
    statmentsAst
  ast: ->
    type: @type()
    id: null
    params: @astOrIdentifier @params
    defaults: []
    body:
      type: 'BlockStatement'
      rest: null
      generator: false
      expression: false
      body: @bodyAst()

_.extend FunctionExpression::, AstBuilder::

module.exports = FunctionExpression
