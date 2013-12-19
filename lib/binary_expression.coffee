class BinaryExpression
  constructor: (@operator, @a, @b) ->
  # TODO - handle expressions in left and right
  ast: ->
    type: 'BinaryExpression'
    operator: @operator
    left:
      type: 'Identifier'
      name: @a
    right:
      type: 'Identifier'
      name: @b

module.exports = BinaryExpression
