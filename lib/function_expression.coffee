ReturnStatement = require './return_statement'

class FunctionExpression
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
  paramsAst: ->
    @params.map (param) ->
      type: 'Identifier'
      name: param
  ast: ->
    type: 'FunctionExpression'
    id: null
    params: @paramsAst()
    defaults: []
    body:
      type: 'BlockStatement'
      rest: null
      generator: false
      expression: false
      body: @bodyAst()

module.exports = FunctionExpression
