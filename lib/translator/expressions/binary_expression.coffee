Expression = require './expression.coffee'

class BinaryExpression extends Expression
  constructor: (@operator, @left, @right) ->
    super()
  type: 'BinaryExpression'
  ast: ->
    type: @type
    operator: @operator
    left: @astOrIdentifier @left
    right: @astOrIdentifier @right

module.exports = BinaryExpression
