class BinaryExpression
  constructor: (@operator, @left, @right) ->
  # TODO - handle expressions in left and right
  ast: ->
    type: 'BinaryExpression'
    operator: @operator
    left:
      type: 'Identifier'
      name: @left
    right:
      type: 'Identifier'
      name: @right

module.exports = BinaryExpression
