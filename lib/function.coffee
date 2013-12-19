class Function
  constructor: (@params) ->
    @body = []
  body: undefined
  bodyAst: ->
    @body.map (statement) -> statement.ast()
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

module.exports = Function
