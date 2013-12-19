class ExpressionStatement
  constructor: (@expression) ->
  expressionAst: ->
    @expression.ast()
  ast: ->
      type: 'ExpressionStatement'
      expression: @expressionAst()

module.exports = ExpressionStatement
