Expression = require './expression.coffee'

class BinaryExpression extends Expression
  constructor: (@operator, @left, @right) ->
  type: 'BinaryExpression'
  # TODO - handle expressions in left and right
  ast: ->
    type: @type
    operator: @operator
    left:
      type: 'Identifier'
      name: @left
    right:
      type: 'Identifier'
      name: @right

module.exports = BinaryExpression
