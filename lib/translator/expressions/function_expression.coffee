ReturnStatement = require '../statements/return_statement'
Expression = require './expression'

class FunctionExpression extends Expression
  constructor: (@params) ->
    @body = []
  body: undefined
  bodyAst: ->
    statmentsAst = []
    for statement, i in @body
      if i == (@body.length - 1) && statement.type != 'ReturnStatement'
        statement = new ReturnStatement(statement.expression)
      statmentsAst.push statement.ast()
    statmentsAst
  ast: ->
    type: 'FunctionExpression'
    id: null
    params: @astOrIdentifier @params
    defaults: []
    body:
      type: 'BlockStatement'
      rest: null
      generator: false
      expression: false
      body: @bodyAst()

module.exports = FunctionExpression
